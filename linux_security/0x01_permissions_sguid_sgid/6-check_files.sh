#!/bin/bash
find $1 -perm /6000 -mtime -1 -ls 2> /dev/null
