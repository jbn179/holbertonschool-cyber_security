#!/bin/bash
find $1 -type f -exec chmod o-wx {} \; 2>/dev/null