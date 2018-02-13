#!/usr/bin/env bats

setup() {
	. ./test/lib/test-helper.sh
	source_exec nsupdate-wrapper.sh
}

# -4, --ipv4-only

@test "_getopts -4" {
	_getopts -4
	[ "$OPT_IPV4" -eq 1 ]
}

@test "_getopts --ipv4-only" {
	_getopts --ipv4-only
	[ "$OPT_IPV4" -eq 1 ]
}

@test "_getopts --ipv4-only=123" {
	run _getopts --ipv4-only=123
	[ "$status" -eq 4 ]
}

# -6, --ipv6-only

@test "_getopts -6" {
	_getopts -6
	[ "$OPT_IPV6" -eq 1 ]
}

@test "_getopts --ipv6-only" {
	_getopts --ipv6-only
	[ "$OPT_IPV6" -eq 1 ]
}

@test "_getopts --ipv6-only=123" {
	run _getopts --ipv6-only=123
	[ "$status" -eq 4 ]
}

# -d, --device

@test "_getopts -d 123" {
	_getopts -d 123
	[ "$OPT_DEVICE" -eq 123 ]
}

@test "_getopts -d" {
	run _getopts -d
	[ "$status" -eq 3 ]
}

@test "_getopts --device=123" {
	_getopts --device=123
	[ "$OPT_DEVICE" -eq 123 ]
}

@test "_getopts --device" {
	run _getopts --device
	[ "$status" -eq 3 ]
}

# -h, --help

@test "_getopts -h" {
	run _getopts -h
	[ "$status" -eq 0 ]
	[ "${lines[0]}" = "nsupdate-wrapper.sh v1.0" ]
}

@test "_getopts --help" {
	run _getopts --help
	[ "$status" -eq 0 ]
	[ "${lines[0]}" = "nsupdate-wrapper.sh v1.0" ]
}

@test "_getopts --help=123" {
	run _getopts --help=123
	[ "$status" -eq 4 ]
}

# -n, --name-server

@test "_getopts -n 123" {
	_getopts -n 123
	[ "$OPT_NAME_SERVER" -eq 123 ]
}

@test "_getopts -n" {
	run _getopts -n
	[ "$status" -eq 3 ]
}

@test "_getopts --name-server=123" {
	_getopts --name-server=123
	[ "$OPT_NAME_SERVER" -eq 123 ]
}

@test "_getopts --name-server" {
	run _getopts --name-server
	[ "$status" -eq 3 ]
}

# -p, --private-key

@test "_getopts -p 123" {
	_getopts -p 123
	[ "$OPT_PRIVATE_KEY" -eq 123 ]
}

@test "_getopts -p" {
	run _getopts -p
	[ "$status" -eq 3 ]
}

@test "_getopts --private-key=123" {
	_getopts --private-key=123
	[ "$OPT_PRIVATE_KEY" -eq 123 ]
}

@test "_getopts --private-key" {
	run _getopts --private-key
	[ "$status" -eq 3 ]
}

# -r, --record

@test "_getopts -r 123" {
	_getopts -r 123
	[ "$OPT_RECORD" -eq 123 ]
}

@test "_getopts -r" {
	run _getopts -r
	[ "$status" -eq 3 ]
}

@test "_getopts --record=123" {
	_getopts --record=123
	[ "$OPT_RECORD" -eq 123 ]
}

@test "_getopts --record" {
	run _getopts --record
	[ "$status" -eq 3 ]
}

# -s, --short-description

@test "_getopts -s" {
	run _getopts -s
	[ "$status" -eq 0 ]
	[ "${lines[0]}" = 'Wrapper around nsupdate. Update your DNS server using nsupdate. Supports both ipv4 and ipv6.' ]
}

@test "_getopts --short-description" {
	run _getopts --short-description
	[ "$status" -eq 0 ]
	[ "${lines[0]}" = 'Wrapper around nsupdate. Update your DNS server using nsupdate. Supports both ipv4 and ipv6.' ]
}

@test "_getopts --short-description=123" {
	run _getopts --short-description=123
	[ "$status" -eq 4 ]
}

# -t, --ttl

@test "_getopts -t 123" {
	_getopts -t 123
	[ "$OPT_TTL" -eq 123 ]
}

@test "_getopts -t" {
	run _getopts -t
	[ "$status" -eq 3 ]
}

@test "_getopts --ttl=123" {
	_getopts --ttl=123
	[ "$OPT_TTL" -eq 123 ]
}

@test "_getopts --ttl" {
	run _getopts --ttl
	[ "$status" -eq 3 ]
}

# -v, --version

@test "_getopts -v" {
	run _getopts -v
	[ "$status" -eq 0 ]
	[ "${lines[0]}" = "1.0" ]
}

@test "_getopts --version" {
	run _getopts --version
	[ "$status" -eq 0 ]
	[ "${lines[0]}" = "1.0" ]
}

@test "_getopts --version=123" {
	run _getopts --version=123
	[ "$status" -eq 4 ]
}
