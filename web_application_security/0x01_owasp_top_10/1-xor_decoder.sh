#!/bin/bash

# WebSphere XOR Decoder Script
# Usage: ./1-xor_decoder.sh {xor}base64_encoded_string

if [ $# -ne 1 ]; then
    echo "Usage: $0 {xor}base64_encoded_string"
    exit 1
fi

input="$1"

# Remove the {xor} prefix
if [[ $input == {xor}* ]]; then
    encoded="${input#\{xor\}}"
else
    echo "Error: Input must start with {xor}"
    exit 1
fi

# Decode base64
decoded=$(echo "$encoded" | base64 -d 2>/dev/null)
if [ $? -ne 0 ]; then
    echo "Error: Invalid base64 encoding"
    exit 1
fi

# WebSphere XOR key (default key used by WebSphere)
key="_"

# XOR decode each byte
result=""
key_len=${#key}
decoded_len=${#decoded}

for ((i=0; i<decoded_len; i++)); do
    # Get character at position i
    char=$(printf "%d" "'${decoded:i:1}")
    # Get key character (cycle through key)
    key_char=$(printf "%d" "'${key:$((i % key_len)):1}")
    # XOR the characters
    xor_result=$((char ^ key_char))
    # Convert back to character
    result+=$(printf "\\$(printf "%03o" $xor_result)")
done

echo "$result"
