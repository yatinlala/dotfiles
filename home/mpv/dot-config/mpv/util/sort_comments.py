#!/usr/bin/env python3
"""Render yt-dlp comments as a compact, colored terminal reader."""
import argparse
import json
import os
import sys
import textwrap
from collections import defaultdict


def clean(value):
    # Only our own ANSI styling should reach the terminal.
    return "".join(c for c in str(value) if c in "\n\t" or (ord(c) >= 32 and not 127 <= ord(c) < 160))


def number(comment, key):
    return comment.get(key) or 0


def render(data, width=80, sort="none", reply_limit=3):
    width = max(20, width)
    lines = []

    def color(text, code):
        return f"\033[{code}m{text}\033[0m"

    def paragraph(text, prefix="  ", code=None):
        for part in clean(text).expandtabs(4).splitlines() or [""]:
            for line in textwrap.wrap(part, width=max(1, width - len(prefix))) or [""]:
                lines.append(prefix + (color(line, code) if code else line))

    comments = data.get("comments") or []
    roots = []
    replies = defaultdict(list)
    for comment in comments:
        if comment.get("parent", "root") == "root":
            roots.append(comment)
        else:
            replies[comment["parent"]].append(comment)

    if sort != "none":
        key = "like_count" if sort == "likes" else "timestamp"
        roots.sort(key=lambda c: number(c, key), reverse=True)

    paragraph("YOUTUBE  /  COMMENTS", code="1;36")
    paragraph(data.get("title") or "Unknown title", code="1")
    paragraph(data.get("channel") or data.get("uploader") or "Unknown channel", code="33")
    lines.append("")

    def comment_block(comment, reply=False):
        prefix = "    │ " if reply else "  "
        badges = []
        if comment.get("is_pinned"):
            badges.append("PINNED")
        if comment.get("author_is_uploader"):
            badges.append("CREATOR")
        author = comment.get("author") or "Unknown author"
        paragraph(author + ("  · " + " · ".join(badges) if badges else ""),
                  prefix, "1;36" if not reply else "36")
        likes = comment.get("like_count")
        paragraph(f"{likes:,} likes" if likes is not None else "likes unavailable", prefix, "33")
        paragraph(comment.get("text") or "[No text]", prefix)
        lines.append("")

    if not roots:
        paragraph("No comments available.", code="90")
    for root in roots:
        lines.append("  " + color("─" * (width - 4), "90"))
        lines.append("")
        comment_block(root)
        thread = sorted(replies.get(root.get("id"), []),
                        key=lambda c: number(c, "like_count"), reverse=True)
        for reply in thread[:reply_limit]:
            comment_block(reply, reply=True)
        if len(thread) > reply_limit:
            paragraph(f"+ {len(thread) - reply_limit} more fetched replies", "    │ ", "90")
            lines.append("")
    return "\n".join(lines)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("json_file", nargs="?", default="-", help="JSON file, or - for stdin (default)")
    parser.add_argument("--sort", choices=["none", "likes", "time"], default="none",
                        help="Root order: preserve YouTube order (default), likes, or time")
    parser.add_argument("--replies", type=int, default=3, help="Replies displayed per thread (default: 3)")
    args = parser.parse_args()
    if args.replies < 0:
        parser.error("--replies must be nonnegative")
    try:
        if args.json_file == "-":
            data = json.load(sys.stdin)
        else:
            with open(args.json_file, encoding="utf-8") as stream:
                data = json.load(stream)
        if not isinstance(data, dict):
            raise ValueError("Expected a video JSON object")
        # stdout is captured by Bash, but stderr is still connected to Kitty.
        try:
            width = os.get_terminal_size(sys.stderr.fileno()).columns
        except OSError:
            width = 80
        print(render(data, width, args.sort, args.replies))
    except (OSError, ValueError) as error:
        print(f"Cannot read comments: {error}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
