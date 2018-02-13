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
