#!/usr/bin/env python3
"""
miniflux-backup.py

Dumps the miniflux2 postgres db, compresses it, keeps a copy locally,
uploads it to Google Drive via rclone, and prunes old backups on both
sides using a grandfather-father-son retention scheme:

    - every backup from the last DAILY_KEEP days
    - one backup per week for WEEKLY_KEEP weeks after that
    - one backup per month for MONTHLY_KEEP months after that
    - anything older is deleted, locally and on the remote
"""
import fcntl
import gzip
import os
import re
import shutil
import subprocess
import sys
from datetime import datetime

### ---------- Config ---------- ###

DB_NAME = "miniflux2"

# Linux user used to run pg_dump. This assumes peer auth: a linux user
# called "miniflux" mapped to a postgres role called "miniflux" that owns
# miniflux2 (this is implied by your `pg_dump miniflux2` with no -U flag).
# If that's not how your auth is set up, edit DUMP_CMD below instead.
DB_USER = "postgres"

LOCAL_BACKUP_DIR = "/var/backups/miniflux"

RCLONE_REMOTE = "gdrive"
RCLONE_PATH = "archive/backups/miniflux"

DAILY_KEEP = 7
WEEKLY_KEEP = 4
MONTHLY_KEEP = 3

LOCK_FILE = "/var/lock/miniflux-backup.lock"

NAME_RE = re.compile(r"^miniflux_(\d{8})_(\d{6})\.sql\.gz$")

### ---------- End config ---------- ###


def log(msg: str) -> None:
    print(f"{datetime.now():%F %T} [miniflux-backup] {msg}", flush=True)


def acquire_lock():
    lock_fh = open(LOCK_FILE, "w")
    try:
        fcntl.flock(lock_fh, fcntl.LOCK_EX | fcntl.LOCK_NB)
    except BlockingIOError:
        log("Another backup run is already in progress, exiting.")
        sys.exit(1)
    return lock_fh  # keep a reference alive for the life of the process


def dump_and_compress(dest_path: str) -> None:
    tmp_path = dest_path + ".tmp"
    # Change this if your DB auth isn't peer-auth as a matching linux user,
    # e.g.: dump_cmd = ["runuser", "-u", "postgres", "--", "pg_dump", DB_NAME]
    dump_cmd = ["runuser", "-u", DB_USER, "--", "pg_dump", DB_NAME]

    log(f"Starting backup of {DB_NAME}")
    try:
        with open(tmp_path, "wb") as f_out:
            gz = gzip.GzipFile(fileobj=f_out, mode="wb", compresslevel=9)
            proc = subprocess.Popen(dump_cmd, stdout=subprocess.PIPE)
            shutil.copyfileobj(proc.stdout, gz)
            proc.stdout.close()
            ret = proc.wait()
            gz.close()
        if ret != 0:
            raise RuntimeError(f"pg_dump exited with status {ret}")
    except Exception:
        if os.path.exists(tmp_path):
            os.remove(tmp_path)
        raise

    os.rename(tmp_path, dest_path)
    size = os.path.getsize(dest_path)
    log(f"Local backup written: {dest_path} ({size / 1024 / 1024:.1f} MiB)")


def upload(dest_path: str) -> None:
    log(f"Uploading to {RCLONE_REMOTE}:{RCLONE_PATH}/")
    subprocess.run(
        ["rclone", "copy", dest_path, f"{RCLONE_REMOTE}:{RCLONE_PATH}/", "--quiet"],
        check=True,
    )
    log("Upload complete")


def parse_date(filename: str):
    m = NAME_RE.match(filename)
    if not m:
        return None
    return datetime.strptime(m.group(1) + m.group(2), "%Y%m%d%H%M%S")


def files_to_delete(filenames, now=None):
    """Given a list of backup filenames, return the ones to delete under
    the GFS retention policy."""
    now = now or datetime.now()
    weekly_window_days = DAILY_KEEP + WEEKLY_KEEP * 7

    entries = []
    for name in filenames:
        d = parse_date(name)
        if d is not None:
            entries.append((d, name))
    entries.sort(key=lambda x: x[0], reverse=True)  # newest first

    keep = set()

    # Daily bucket: everything within the last N days.
    for d, name in entries:
        if (now - d).days <= DAILY_KEEP:
            keep.add(name)

    # Weekly bucket: newest backup per ISO (year, week) for the next window.
    seen_weeks = set()
    for d, name in entries:
        if name in keep:
            continue
        age_days = (now - d).days
        if age_days <= DAILY_KEEP or age_days > weekly_window_days:
            continue
        week_key = d.isocalendar()[:2]
        if week_key not in seen_weeks:
            seen_weeks.add(week_key)
            keep.add(name)

    # Monthly bucket: newest backup per (year, month) for the next N months.
    seen_months = set()
    for d, name in entries:
        if name in keep:
            continue
        age_days = (now - d).days
        if age_days <= weekly_window_days:
            continue
        months_back = (now.year - d.year) * 12 + (now.month - d.month)
        if months_back > MONTHLY_KEEP:
            continue
        month_key = (d.year, d.month)
        if month_key not in seen_months:
            seen_months.add(month_key)
            keep.add(name)

    return [name for d, name in entries if name not in keep]


def prune_local() -> None:
    log("Pruning local backups")
    filenames = [
        f for f in os.listdir(LOCAL_BACKUP_DIR)
        if NAME_RE.match(f)
    ]
    for name in files_to_delete(filenames):
        log(f"Deleting local: {name}")
        os.remove(os.path.join(LOCAL_BACKUP_DIR, name))


def prune_remote() -> None:
    log("Pruning remote backups")
    result = subprocess.run(
        ["rclone", "lsf", f"{RCLONE_REMOTE}:{RCLONE_PATH}/", "--files-only"],
        check=True,
        capture_output=True,
        text=True,
    )
    filenames = [line.strip() for line in result.stdout.splitlines() if line.strip()]
    for name in files_to_delete(filenames):
        log(f"Deleting remote: {name}")
        subprocess.run(
            ["rclone", "deletefile", f"{RCLONE_REMOTE}:{RCLONE_PATH}/{name}"],
            check=True,
        )


def main():
    lock_fh = acquire_lock()  # noqa: F841 (kept alive for lock duration)

    os.makedirs(LOCAL_BACKUP_DIR, exist_ok=True)

    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    dest_path = os.path.join(LOCAL_BACKUP_DIR, f"miniflux_{timestamp}.sql.gz")

    dump_and_compress(dest_path)
    upload(dest_path)
    prune_local()
    prune_remote()

    log("Backup and prune complete")


if __name__ == "__main__":
    main()
