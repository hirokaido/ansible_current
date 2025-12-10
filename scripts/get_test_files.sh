#--------------------------------------
#!/usr/bin/env bash
# ./scripts/get_test_files.sh linux|windows
set -euo pipefail

TARGET="$1"
OUTPUT_FILE="${TARGET}_tests.txt"
rm -f "$OUTPUT_FILE"

# コミット差分の Python ファイルだけ取得
FILES=$(git diff --name-only HEAD^..HEAD || true | grep '\.py$' || true)

for file in $FILES; do
    [ -f "$file" ] || continue
    if grep -q "target:${TARGET}" "$file"; then
        echo "$file" >> "$OUTPUT_FILE"
    fi
done

if [ -s "$OUTPUT_FILE" ]; then
    echo "${TARGET^} tests found:"
    cat "$OUTPUT_FILE"
else
    echo "No ${TARGET^} tests to run"
fi
