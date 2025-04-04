g() {
  EXTRACTED_JUMPS=$(grep -E "map .* cd .*" ~/.config/lf/lfrc | sed "s/map g//" | sed "s/ cd//")

  if [ -z "$1" ]; then
    echo "Usage: $0 <acronym>"
   return 1
  fi

  ACRONYM="$1"

  MATCH=$(echo $EXTRACTED_JUMPS | grep -E "^$ACRONYM\s+")

  if [ -z "$MATCH" ]; then
    echo "No matching acronym found."
    return 1
  fi

  DIR=$(echo "$MATCH" | awk '{print $2}')

  # Expand ~ to the user's home directory if present.
  DIR="${DIR/#\~/$HOME}"

  # Check if the directory exists.
  if [ ! -d "$DIR" ]; then
    echo "Directory $DIR does not exist."
    return 1
  fi

  echo "✨"
  cd "$DIR" || return 1
}
