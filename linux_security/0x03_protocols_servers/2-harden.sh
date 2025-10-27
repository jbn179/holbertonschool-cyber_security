#!/bin/bash
find / -type d -perm -002 -xdev -print -exec chmod o-w {} +