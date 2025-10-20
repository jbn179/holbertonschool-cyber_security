#!/bin/bash
john --w=/usr/share/wordlists/rockyou.txt --format=raw-sha256 $1
