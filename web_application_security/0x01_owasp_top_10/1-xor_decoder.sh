#!/bin/bash

input="$1"
input="${input#'{xor}'}"
decoded_input=$(echo "$input" | base64 -d)
output=""

i=0
while [ $i -lt ${#decoded_input} ]
do
	char="${decoded_input:$i:1}"
	ascii_val=$(printf "%d" "'$char")
	xor_result=$(( ascii_val ^ 95 ))
	output+=$(printf "\\$(printf '%03o' $xor_result)")
	i=$((i + 1))
done

echo "$output"