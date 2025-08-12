#!/bin/bash
whois "$1" | awk '/^(Registrant|Admin|Tech)/ { gsub(/[[:space:]]+/, " "); sub(": ", ","); print }' > "$1.csv"
