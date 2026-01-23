#!/bin/bash
# Show YouTube video description in a terminal window

VIDEO_PATH="$1"
TEMP_JSON="/tmp/yt_description_$$.json"

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
            notify-send "MPV Description" "No YouTube URL found in video metadata" 2>/dev/null
            exit 1
        fi
    fi

    # Fetch video info using yt-dlp (silently)
    yt-dlp --skip-download --write-info-json --output "$TEMP_JSON" "$VIDEO_URL" >/dev/null 2>&1

    # Check if info was fetched
    if [ ! -f "${TEMP_JSON}.info.json" ]; then
        notify-send "MPV Description" "Failed to fetch video info" 2>/dev/null
        exit 1
    fi

    # Extract and format description
    TITLE=$(jq -r '.title // "Unknown Title"' "${TEMP_JSON}.info.json")
    CHANNEL=$(jq -r '.channel // .uploader // "Unknown Channel"' "${TEMP_JSON}.info.json")
    UPLOAD_DATE=$(jq -r '.upload_date // ""' "${TEMP_JSON}.info.json" | sed 's/\(....\)\(..\)\(..\)/\1-\2-\3/')
    VIEW_COUNT=$(jq -r '.view_count // ""' "${TEMP_JSON}.info.json" | sed ':a;s/\B[0-9]\{3\}\>/,&/;ta')
    LIKE_COUNT=$(jq -r '.like_count // ""' "${TEMP_JSON}.info.json" | sed ':a;s/\B[0-9]\{3\}\>/,&/;ta')
    DESCRIPTION=$(jq -r '.description // "No description available"' "${TEMP_JSON}.info.json")

    # Open in kitty with less pager
    kitty --title="MPV: YouTube Description" bash -c "
        echo -e '\033[1;36m$TITLE\033[0m'
        echo -e '\033[1;33m$CHANNEL\033[0m'
        echo ''
        [ -n '$UPLOAD_DATE' ] && echo -e '\033[0;90mUploaded: $UPLOAD_DATE\033[0m'
        [ -n '$VIEW_COUNT' ] && echo -e '\033[0;90mViews: $VIEW_COUNT\033[0m'
        [ -n '$LIKE_COUNT' ] && echo -e '\033[0;90mLikes: $LIKE_COUNT\033[0m'
        echo ''
        echo -e '\033[0;37m$DESCRIPTION\033[0m'
        rm -f '${TEMP_JSON}.info.json'
    " | less -R
) &

# Exit immediately so MPV doesn't wait
exit 0
