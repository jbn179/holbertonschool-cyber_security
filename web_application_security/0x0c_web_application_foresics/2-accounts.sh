#!/bin/bash
comm -12 <(tail -1000 auth.log | grep "Accepted password" | awk '{print $9}' | sort -u) <(tail -1000 auth.log | grep "Failed password" | awk '{print $9}' | sort -u)
