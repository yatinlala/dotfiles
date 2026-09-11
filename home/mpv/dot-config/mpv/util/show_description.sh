#!/bin/bash
# Run inside Kitty; keep fetched metadata in memory and pipe text to the pager.

VIDEO_PATH="$1"

youtube_url() {
    grep -oE 'https?://(www\.|m\.|music\.)?(youtube\.com|youtu\.be)/[^[:space:]"<>]+' | head -1
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

    if [ -z "$VIDEO_URL" ]; then
        notify-send "MPV Description" "No YouTube URL found in video metadata" 2>/dev/null
        exit 1
    fi
fi

# Check the fetch before opening less so errors do not leave an empty pager.
if ! VIDEO_JSON=$(yt-dlp --dump-json --no-playlist -- "$VIDEO_URL"); then
    notify-send "MPV Description" "Failed to fetch video info" 2>/dev/null
    exit 1
fi

jq -r '
    def count: tostring | gsub("(?<=\\d)(?=(\\d{3})+$)"; ",");
    "\u001b[1;36m\(.title // "Unknown Title")\u001b[0m",
    "\u001b[1;33m\(.channel // .uploader // "Unknown Channel")\u001b[0m\n",
    (if .upload_date then
        "\u001b[0;90mUploaded: \(.upload_date | sub("^(?<y>[0-9]{4})(?<m>[0-9]{2})(?<d>[0-9]{2})$"; "\(.y)-\(.m)-\(.d)"))\u001b[0m"
    else empty end),
    (if .view_count != null then "\u001b[0;90mViews: \(.view_count | count)\u001b[0m" else empty end),
    (if .like_count != null then "\u001b[0;90mLikes: \(.like_count | count)\u001b[0m" else empty end),
    "\n\(.description // "No description available")"
' <<< "$VIDEO_JSON" | less -R
