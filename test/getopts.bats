#!/usr/bin/env bats

setup() {
	. ./test/lib/test-helper.sh
	source_exec nsupdate-wrapper.sh
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
