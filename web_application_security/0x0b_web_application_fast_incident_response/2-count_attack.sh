#!/bin/bash
grep -c "^$(awk '{print $1}' logs.txt | sort | uniq -c | sort -nr | head -n 1 | awk '{print $2}')" logs.txt