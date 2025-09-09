#!/bin/bash
curl -s -H "Host: $1" -X POST "$2" -d "$3"
