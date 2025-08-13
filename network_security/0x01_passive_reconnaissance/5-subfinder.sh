#!/bin/bash
subfinder -d "$1" -silent | tee >(while read subdomain; do ip=$(dig +short "$subdomain" | grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' | head -1); [ ! -z "$ip" ] && echo "${subdomain},${ip}" >> "${1}.txt"; done)
