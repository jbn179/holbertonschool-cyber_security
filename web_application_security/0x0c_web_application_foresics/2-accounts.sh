#!/bin/bash
comm -12 <(tail -1000 auth.log | grep "Accepted password" | grep -v "invalid user" | awk '{print $9}' | sort -u) <(tail -1000 auth.log | grep "Failed password" | grep -oP 'for \K\w+' | sort -u)
