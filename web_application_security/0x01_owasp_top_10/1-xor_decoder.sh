#!/bin/bash

input="$1"
input="${input#'{xor}'}"
decoded_input=$(echo "$input" | base64 -d)
output=""

i=0
while [ $i -lt ${#decoded_input} ]
do
	char="${decoded_input:$i:1}"
	xor_result=$(( $(printf "%d" "'$char") ^ 95 ))
	output+=$(printf "\\$(printf '%03o' $xor_result)")
	i=$((i + 1))
done

echo "$output"
