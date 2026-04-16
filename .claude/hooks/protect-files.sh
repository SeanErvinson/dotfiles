#!/bin/bash
# protect-files.sh

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')
BASENAME=$(basename "$FILE_PATH")

PROTECTED_EXACT=(".env" "package-lock.json")
PROTECTED_SUBSTR=(".git/")

for pattern in "${PROTECTED_EXACT[@]}"; do
  if [[ "$BASENAME" == "$pattern" ]]; then
    echo "Blocked: $FILE_PATH matches protected pattern '$pattern'" >&2
    exit 2
  fi
done

for pattern in "${PROTECTED_SUBSTR[@]}"; do
  if [[ "$FILE_PATH" == *"$pattern"* ]]; then
    echo "Blocked: $FILE_PATH matches protected pattern '$pattern'" >&2
    exit 2
  fi
done

exit 0