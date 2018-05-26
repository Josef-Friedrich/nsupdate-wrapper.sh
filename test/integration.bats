#!/usr/bin/env bats

setup() {
	. ./test/lib/test-helper.sh
	mock_path test/bin
}

@test "./nsupdate-wrapper.sh" {
	run ./nsupdate-wrapper.sh
	[ "$status" -eq 11 ]
}

@test "./nsupdate-wrapper.sh -h" {
	run ./nsupdate-wrapper.sh -h
	[ "$status" -eq 0 ]
}

ARGUMENTS="--zone=example.com. \
--name-server=ns.example.com \
--record=sub.example.com. \
--device=eno1"

LITERAL_KEY="--literal-key=hmac-sha256:example.com:n+WgaHXqgopqlovvjfwnF+TEDUVIQXIXQ0ni+HOQew8="

@test "./nsupdate-wrapper.sh full example" {
	run ./nsupdate-wrapper.sh $ARGUMENTS $LITERAL_KEY
	[ "$status" -eq 0 ]
	[ "${lines[0]}" = 'Input: server ns.example.com' ]
	[ "${lines[1]}" = 'Input: zone example.com.' ]
	[ "${lines[2]}" = 'Input: update delete sub.example.com. A' ]
	[ "${lines[3]}" = 'Input: update add sub.example.com. 300 A 1.2.3.4' ]
	[ "${lines[4]}" = 'Input: show' ]
	[ "${lines[5]}" = 'Input: send' ]
	[ "${lines[6]}" = 'Arg: -y' ]
	[ "${lines[7]}" = 'Arg: hmac-sha256:example.com:n+WgaHXqgopqlovvjfwnF+TEDUVIQXIXQ0ni+HOQew8=' ]
	[ "${lines[8]}" = 'Input: server ns.example.com' ]
	[ "${lines[9]}" = 'Input: zone example.com.' ]
	[ "${lines[10]}" = 'Input: update delete sub.example.com. AAAA' ]
	[ "${lines[11]}" = 'Input: update add sub.example.com. 300 AAAA 200c:ef45:4c06:3300:b832:fe2d:bb21:60bd' ]
	#echo ${lines[11]} > $HOME/debug
}

@test "./nsupdate-wrapper.sh without key" {
	run ./nsupdate-wrapper.sh $ARGUMENTS
	[ "$status" -eq 0 ]
	[ "${lines[0]}" = 'Input: server ns.example.com' ]
	[ "${lines[1]}" = 'Input: zone example.com.' ]
	[ "${lines[2]}" = 'Input: update delete sub.example.com. A' ]
	[ "${lines[3]}" = 'Input: update add sub.example.com. 300 A 1.2.3.4' ]
	[ "${lines[4]}" = 'Input: show' ]
	[ "${lines[5]}" = 'Input: send' ]
	[ "${lines[6]}" = 'Input: server ns.example.com' ]
}

@test "./nsupdate-wrapper.sh --key-file" {
	run ./nsupdate-wrapper.sh --key-file=Kexample.com+163+43844.key $ARGUMENTS
	[ "$status" -eq 0 ]
	[ "${lines[6]}" = 'Arg: -k' ]
	[ "${lines[7]}" = 'Arg: Kexample.com+163+43844.key' ]
}

@test "./nsupdate-wrapper.sh -4" {
	run ./nsupdate-wrapper.sh -4 $ARGUMENTS $LITERAL_KEY
	[ "$status" -eq 0 ]
	[ "${lines[0]}" = 'Input: server ns.example.com' ]
	[ "${lines[1]}" = 'Input: zone example.com.' ]
	[ "${lines[2]}" = 'Input: update delete sub.example.com. A' ]
	[ "${lines[3]}" = 'Input: update add sub.example.com. 300 A 1.2.3.4' ]
	[ "${lines[4]}" = 'Input: show' ]
	[ "${lines[5]}" = 'Input: send' ]
	[ "${lines[6]}" = 'Arg: -y' ]
	[ "${lines[7]}" = 'Arg: hmac-sha256:example.com:n+WgaHXqgopqlovvjfwnF+TEDUVIQXIXQ0ni+HOQew8=' ]
	[ -z "${lines[8]}" ]
}

@test "./nsupdate-wrapper.sh -6" {
	run ./nsupdate-wrapper.sh -6 $ARGUMENTS $LITERAL_KEY
	[ "$status" -eq 0 ]
	[ "${lines[2]}" = 'Input: update delete sub.example.com. AAAA' ]
	[ -z "${lines[8]}" ]
}
