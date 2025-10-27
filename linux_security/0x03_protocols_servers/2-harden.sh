#!/bin/bash
find / -type d -perm -002 -print -exec chmod o-w {} \;