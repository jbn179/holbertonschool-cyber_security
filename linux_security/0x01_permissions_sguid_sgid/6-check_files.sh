#!/bin/bash
find $1 -perm /6000 -mtime 0 -exec ls -l {} \; 2> /dev/null
