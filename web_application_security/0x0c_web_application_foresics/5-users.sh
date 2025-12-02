#!/bin/bash
grep "new user:" auth.log | grep -oP 'name=\K[^,]+' | sort -u | paste -sd,
