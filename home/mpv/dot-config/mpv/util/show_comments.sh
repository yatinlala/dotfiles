#!/bin/bash
# Run inside Kitty. No metadata or rendered text is written to disk.
VIDEO_PATH="$1"
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)

youtube_url() {
    grep -oE 'https?://(www\.|m\.|music\.)?(youtube\.com|youtu\.be)/[^[:space:]"<>]+' | head -1
}

fail() {
    printf '\n%s\n' "$1" >&2
    notify-send "MPV Comments" "$1" 2>/dev/null
    exit 1
}

if [[ "$VIDEO_PATH" =~ ^https?:// ]]; then
    VIDEO_URL="$VIDEO_PATH"
else
    VIDEO_URL=$(ffprobe -v quiet -print_format json -show_format "$VIDEO_PATH" 2>/dev/null |
        jq -r '.format.tags // {} | to_entries[] | select(.key | ascii_downcase == "comment") | .value' |
        youtube_url)
    if [ -z "$VIDEO_URL" ]; then
        VIDEO_URL=$(mediainfo "$VIDEO_PATH" 2>/dev/null |
            grep -i '^Comment' | youtube_url)
    fi
    [ -n "$VIDEO_URL" ] || fail "No YouTube URL found in video metadata"
fi

printf '\033[1;36mLoading top comments…\033[0m\n'
# Keep YouTube top order. Fetch up to 30 threads and 10 replies per thread;
# the renderer displays the three most-liked replies from each fetched sample.
if ! VIDEO_JSON=$(yt-dlp --dump-json --no-playlist --write-comments \
    --extractor-args "youtube:comment_sort=top;max_comments=330,30,300,10" -- "$VIDEO_URL"); then
    fail "Failed to fetch comments"
fi

if ! COMMENTS=$(python3 "$SCRIPT_DIR/sort_comments.py" <<< "$VIDEO_JSON"); then
    fail "Failed to format comments"
fi
printf '%s\n' "$COMMENTS" | less -R
