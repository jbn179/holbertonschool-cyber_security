#!/bin/bash
whois $1 | awk -F: '{print $1","$2}' > $1.csv
