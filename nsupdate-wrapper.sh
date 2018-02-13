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

Usage: $NAME [-AdhrSstv]

$SHORT_DESCRIPTION

Options:
	-h, --help
	  Show this help message.
	-n, --nameserver
	  DNS server to send updates to.
	-p, --private-key
	  Path to private key.
	-r, --record
	  Record to update.
	-s, --short-description
	  Show a short description / summary.
	-t, --ttl
	  Time to live for updated record; default 3600s.
	-v, --version
	  Show the version number of this script.
	-z, --zone
	  Zone to update

"

# See https://stackoverflow.com/a/28466267

# Exit codes
# Invalid option: 2
# Missing argument: 3
# No argument allowed: 4
_getopts() {
	while getopts ':hn:p:r:st:vz:-:' OPT ; do
		case $OPT in

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
					help) echo "$USAGE" ; exit 0 ;;
					name-server=?*) OPT_NAME_SERVER="$LONG_OPTARG" ;;
					private-key=?*) OPT_PRIVATE_KEY="$LONG_OPTARG" ;;
					record=?*) OPT_RECORD="$LONG_OPTARG" ;;
					short-description) echo "$SHORT_DESCRIPTION" ; exit 0 ;;
					ttl) OPT_TTL="$LONG_OPTARG" ;;
					version) echo "$VERSION" ; exit 0 ;;

					name-server*|private-key*|record*|ttl*)
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

_get_external_ipv4() {
	external_ip=$(curl -s 'http://checkip.dyndns.org' | sed 's/.*Current IP Address: \([0-9\.]\{7,15\}\).*/\1/')
}

_get_ipv6() {
	address=$(ip -6 addr list scope global $device | grep -v " fd" | sed -n 's/.*inet6 \([0-9a-f:]\+\).*/\1/p' | head -n 1)
}

_nsupdate() {
	nsupdate_out=$(echo "server $nameserver
	zone $zone
	update delete $record A
	update add $record $ttl A $external_ip
	show
	send" | nsupdate -k $priv_key -v 2>&1)
	logger "$nsupdate_out"
}

## This SEPARATOR is required for test purposes. Please don’t remove! ##
