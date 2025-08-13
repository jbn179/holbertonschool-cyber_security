#!/bin/bash
whois $1 | awk -F': ' '/egistrant|dmin|ech/ {printf "%s,%s\n", $1, $2}' > "$1.csv"
