#!/bin/bash
whois $1 | awk -F': ' '/(Registrant|Admin|Tech)/ {printf "%s,%s\n", $1, $2}' > $1.csv
