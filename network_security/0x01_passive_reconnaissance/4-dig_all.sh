#!/bin/bash
for type in A AAAA NS SOA MX TXT CNAME SRV PTR CAA; do dig +noall +answer $1 $type; done
