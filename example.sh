#!/bin/sh

str2enum2str() {
	node str2lower2enum2der.mjs |
		xxd -ps |
		python3 \
			-m asn1tools \
			convert \
			-i der \
			-o jer \
			./method.asn \
			HttpMethodEnum \
			- |
		jq -c
}

str2enum2fq() {
	node str2lower2enum2der.mjs |
    fq -d asn1_ber
}

str2enum2fq
