#! /bin/sh

# MIT License
#
# Copyright (c) 2018 Josef Friedrich <josef@friedrich.rocks>
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

NAME="nsupdate-wrapper.sh"
PROJECT_NAME="nsupdate-wrapper"
FIRST_RELEASE=2018-02-13
VERSION=1.0
PROJECT_PAGES="https://github.com/JosefFriedrich-shell/nsupdate-wrapper.sh"
SHORT_DESCRIPTION='Wrapper around nsupdate. Update your DNS server using nsupdate. Supports both ipv4 and ipv6.'
USAGE="$NAME v$VERSION

Usage: $NAME [-dhnprstvz]

$SHORT_DESCRIPTION

Options:
	-d, --device
	  The interface (device to look for an IP address), e. g. “eth0”
	-h, --help
	  Show this help message.
	-n, --nameserver
	  DNS server to send updates to, e. g. “ns.example.com”
	-p, --private-key
	  Path to private key.
	-r, --record
	  Record to update, e. g. “subdomain.example.com.”
	-s, --short-description
	  Show a short description / summary.
	-t, --ttl
	  Time to live for updated record; default 3600s., e. g. “300”
	-v, --version
	  Show the version number of this script.
	-z, --zone
	  Zone to update, e. g. “example.com.”

"

# See https://stackoverflow.com/a/28466267

# Exit codes
# Invalid option: 2
# Missing argument: 3
# No argument allowed: 4
_getopts() {
	while getopts ':d:hn:p:r:st:vz:-:' OPT ; do
		case $OPT in

			d) OPT_DEVICE="$OPTARG" ;;
			h) echo "$USAGE" ; exit 0 ;;
			n) OPT_NAME_SERVER="$OPTARG" ;;
			p) OPT_PRIVATE_KEY="$OPTARG" ;;
			r) OPT_RECORD="$OPTARG" ;;
			s) echo "$SHORT_DESCRIPTION" ; exit 0 ;;
			t) OPT_TTL="$OPTARG" ;;
			v) echo "$VERSION" ; exit 0 ;;
			z) OPT_ZONE="$OPTARG" ;;
			\?) echo "Invalid option “-$OPTARG”!" >&2 ; exit 2 ;;
			:) echo "Option “-$OPTARG” requires an argument!" >&2 ; exit 3 ;;

			-)
				LONG_OPTARG="${OPTARG#*=}"

				case $OPTARG in
					device=?*) OPT_DEVICE="$LONG_OPTARG" ;;
					help) echo "$USAGE" ; exit 0 ;;
					name-server=?*) OPT_NAME_SERVER="$LONG_OPTARG" ;;
					private-key=?*) OPT_PRIVATE_KEY="$LONG_OPTARG" ;;
					record=?*) OPT_RECORD="$LONG_OPTARG" ;;
					short-description) echo "$SHORT_DESCRIPTION" ; exit 0 ;;
					ttl=?*) OPT_TTL="$LONG_OPTARG" ;;
					version) echo "$VERSION" ; exit 0 ;;

					device*|name-server*|private-key*|record*|ttl*)
						echo "Option “--$OPTARG” requires an argument!" >&2
						exit 3
						;;

					help*|short-description*|version*)
						echo "No argument allowed for the option “--$OPTARG”!" >&2
						exit 4
						;;

					'') break ;; # "--" terminates argument processing
					*) echo "Invalid option “--$OPTARG”!" >&2 ; exit 2 ;;

				esac
				;;

		esac
	done
	GETOPTS_SHIFT=$((OPTIND - 1))
}

_get_ipv4() {
	ipaddr=`ip -4 addr show dev ${wan} | grep inet | sed -e 's/.*inet \([.0-9]*\).*/\1/'`

}

# https://github.com/phoemur/ipgetter/blob/master/ipgetter.py
_get_external_ipv4() {
	curl -s http://myexternalip.com/raw
	http://v6.ident.me/

	external_ip=$(curl -s 'http://checkip.dyndns.org' | sed 's/.*Current IP Address: \([0-9\.]\{7,15\}\).*/\1/')
}


_get_external_ipv6() {
	http://v6.ident.me/
}

_get_ipv6() {
	if [ -z "$OPT_DEVICE" ] ; then
		echo "No device given!" >&2
		exit 9
	fi
	ip -6 addr list scope global $OPT_DEVICE | \
		grep -v " fd" | \
		sed -n 's/.*inet6 \([0-9a-f:]\+\).*/\1/p' | head -n 1
}

_get_nsupdate_commands() {
	if [ -n "$IPV6" ]; then
		RESOURCE_RECORD_TYPE='AAAA'
		IP="$IPV6"
	else
		RESOURCE_RECORD_TYPE='A'
		IP="$IPV4"
	fi
	echo "server $OPT_NAMESERVER
zone $OPT_ZONE
update delete $OPT_RECORD $RESOURCE_RECORD_TYPE
update add $OPT_RECORD $OPT_TTL $RESOURCE_RECORD_TYPE $IP
send"
}

_check_get_binaries() {
	if command -v curl > /dev/null 2>&1 ; then
		#-f, --fail -> exit code 22 on error
		#-s, --silent
		BIN="curl -fs"
	elif command -v wget > /dev/null 2>&1 ; then
		BIN="wget -q -O -"
	else
		echo "Neither curl nor wget found!"
		exit 1
	fi
}

## This SEPARATOR is required for test purposes. Please don’t remove! ##
