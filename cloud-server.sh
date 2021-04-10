#!/bin/bash

# Find out what cloud service a host is running on.
# Dependencies:
# 	- whois

if [[ $1 == "" ]]; then
	echo "Usage: ./cloud-server.sh <host>";
	exit 1;
fi

ip=$(host "$1" | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b")
while read -r host; do
	whois "$host" | grep OrgName | awk '{print $2, $3 , $4}'
done <<< "$ip"
