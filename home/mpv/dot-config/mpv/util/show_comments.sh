#!/bin/bash
# Save this as: ~/.config/mpv/scripts/show_comments.sh

VIDEO_PATH="$1"
TEMP_JSON="/tmp/yt_comments_$$.json"
PYTHON_SCRIPT="$HOME/.config/mpv/util/sort_comments.py"

# Run everything in background, completely detached from MPV
(
    # Check if it's a URL or a file
    if [[ "$VIDEO_PATH" =~ ^https?:// ]]; then
        # It's already a URL
        VIDEO_URL="$VIDEO_PATH"
    else
        # It's a local file - try to extract YouTube URL from metadata
        VIDEO_URL=$(ffprobe -v quiet -print_format json -show_format "$VIDEO_PATH" 2>/dev/null | \
                    grep -oP '"comment":\s*"\K[^"]*' | \
                    grep -E 'youtube\.com|youtu\.be' | head -1)
        
        # If ffprobe didn't work, try mediainfo
        if [ -z "$VIDEO_URL" ]; then
            VIDEO_URL=$(mediainfo "$VIDEO_PATH" 2>/dev/null | \
                       grep -i "^Comment" | \
                       grep -oE 'https?://[^[:space:]]+' | \
                       grep -E 'youtube\.com|youtu\.be' | head -1)
        fi
        
        if [ -z "$VIDEO_URL" ]; then
            notify-send "MPV Comments" "No YouTube URL found in video metadata" 2>/dev/null
            exit 1
        fi
    fi

    # Fetch comments using yt-dlp (silently)
    yt-dlp --skip-download --write-comments --extractor-args "youtube:comment_sort=top;max_comments=100" --output "$TEMP_JSON" "$VIDEO_URL" >/dev/null 2>&1

    # Check if comments were fetched
    if [ ! -f "${TEMP_JSON}.info.json" ]; then
        notify-send "MPV Comments" "Failed to fetch comments" 2>/dev/null
        exit 1
    fi

    # Open in kitty with less pager
    kitty --title="MPV: YouTube Comments" bash -c "python3 '$PYTHON_SCRIPT' '${TEMP_JSON}.info.json' | less -R; rm -f '${TEMP_JSON}.info.json'" >/dev/null 2>&1
) &

# Exit immediately so MPV doesn't wait
exit 0
