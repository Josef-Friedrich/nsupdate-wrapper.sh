#! /bin/sh

./nsupdate-wrapper.sh \
	--zone=jf-dyndns.cf. \
	--name-server=ns.friedrich.rocks \
	--record=w-wnas.jf-dyndns.cf. \
	--literal-key='hmac-sha256:jf-dyndns.cf:n+WgaHXqgopqlovvjfwnF+TEDUVIQXIXQ0ni+HOQew8='

	#--key-file=Kjf-dyndns.cf.+163+43844.key 
