#!/usr/bin/env bats

setup() {
	. ./test/lib/test-helper.sh
	source_exec nsupdate-wrapper.sh
}

@test "_check_get_binaries" {
	run _check_get_binaries
	[ "$status" -eq 0 ]

	_check_get_binaries
	[ "$BIN" = "curl -fs" ]
}

@test "_get_nsupdate_commands" {
	OPT_NAMESERVER='ns.example.com'
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
	[ "${lines[4]}" = "send" ]
}

@test "_get_nsupdate_commands ipv6" {
	OPT_NAMESERVER='ns.example.com'
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
	[ "${lines[4]}" = "send" ]
}

@test "_get_ipv6" {
	OPT_DEVICE='XXX'
	run _get_ipv6
	[ "$status" -eq 0 ]
}

@test "_get_ipv6: no device" {
	run _get_ipv6
	[ "$status" -eq 9 ]
	[ "${lines[0]}" = "No device given!" ]
}
