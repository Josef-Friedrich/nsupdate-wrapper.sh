#!/usr/bin/env bats

setup() {
	. ./test/lib/test-helper.sh
	source_exec nsupdate-wrapper.sh
}

@test "_get_binary" {
	run _get_binary
	[ "$status" -eq 0 ]
	[  "$(_get_binary)" = 'curl -fs' ]
}

@test "_get_nsupdate_commands" {
	OPT_NAME_SERVER='ns.example.com'
	OPT_ZONE='example.com'
	OPT_RECORD='sub.example.com.'
	OPT_TTL='123'
	IPV4='1.2.3.4'
	run _get_nsupdate_commands
	[ "$status" -eq 0 ]
	[ "${lines[0]}" = "server ns.example.com" ]
	[ "${lines[1]}" = "zone example.com" ]
	[ "${lines[2]}" = "update delete sub.example.com. A" ]
	[ "${lines[3]}" = "update add sub.example.com. 123 A 1.2.3.4"  ]
	[ "${lines[4]}" = "show" ]
	[ "${lines[5]}" = "send" ]
}

@test "_get_nsupdate_commands ipv6" {
	OPT_NAME_SERVER='ns.example.com'
	OPT_ZONE='example.com'
	OPT_RECORD='sub.example.com.'
	OPT_TTL='123'
	IPV6='1::1'
	run _get_nsupdate_commands
	[ "$status" -eq 0 ]
	[ "${lines[0]}" = "server ns.example.com" ]
	[ "${lines[1]}" = "zone example.com" ]
	[ "${lines[2]}" = "update delete sub.example.com. AAAA" ]
	[ "${lines[3]}" = "update add sub.example.com. 123 AAAA 1::1"  ]
	[ "${lines[4]}" = "show" ]
	[ "${lines[5]}" = "send" ]
}

@test "_get_ipv6" {
	OPT_DEVICE='XXX'
	run _get_ipv6
	[ "$status" -eq 0 ]

	mock_path test/bin
	IPV6="$(_get_ipv6)"
	[ "$IPV6" = '200c:ef45:4c06:3300:b832:fe2d:bb21:60bd' ]
}

@test "_get_ipv6: no device" {
	run _get_ipv6
	[ "$status" -eq 9 ]
	[ "${lines[0]}" = "No device given!" ]
}

@test "_get_external_ipv4" {
	mock_path test/bin
	BINARY="$(_get_binary)"
	IPV4="$(_get_external_ipv4)"
	[ "$IPV4" = '1.2.3.4' ]
}
