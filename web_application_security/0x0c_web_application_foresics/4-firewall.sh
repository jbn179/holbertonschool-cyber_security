#!/bin/bash
grep -E "iptables -[AI]" auth.log | wc -l
