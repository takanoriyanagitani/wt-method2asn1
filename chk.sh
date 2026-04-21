#!/bin/sh

method_chk(){
	python3 \
		-m asn1tools \
		convert \
		-i jer \
		-o der \
		./method.asn \
		HttpMethodEnum \
		$(echo '"trace"' | xxd -ps) |
		xxd -r -ps |
		xxd
}

method_chk
