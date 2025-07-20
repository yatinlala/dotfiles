#!/bin/bash

diary_path="$HOME/documents/notes/diary/$(date +%F).md"

if [[ ! -f "$diary_path" ]]; then
  echo "👿"
  exit 0
fi

# Count checked and unchecked todos between "todo:" and "notes:"
read unchecked checked <<< $(awk '
  BEGIN { in_todo = 0; unchecked = 0; checked = 0 }
  /^todo:/ { in_todo = 1; next }
  /^notes:/ { in_todo = 0 }
  in_todo {
    if ($0 ~ /^\s*-\s\[\s\]/) unchecked++
    else if ($0 ~ /^\s*-\s\[x\]/i) checked++
  }
  END { print unchecked, checked }
' "$diary_path")

if [[ "$unchecked" -eq 0 && "$checked" -gt 0 ]]; then
  echo "✅"
elif [[ "$unchecked" -eq 0 && "$checked" -eq 0 ]]; then
  echo "😢"
else
  echo "$unchecked 📓"
fi
