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

NAME="$(basename "$0")"
PROJECT_NAME="$(basename "$(pwd)")"
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
	-p, --privkey
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
	while getopts ':Aab:cdhrSstv-:' OPT ; do
		case $OPT in
			A) OPT_ALL=1;;
			a)
				OPT_ALPHA=1
				;;

			b)
				OPT_BRAVO="$OPTARG"
				;;

			c)
				OPT_CHARLIE=1
				;;

			d) OPT_DEPENDENCIES=1 ;;
			h) echo "$USAGE" ; exit 0 ;;
			r) OPT_README=1 ;;
			S) OPT_SKELETON=1 ;;
			s) echo "$SHORT_DESCRIPTION" ; exit 0 ;;
			t) OPT_TEST=1;;
			v) echo "$VERSION" ; exit 0 ;;

			\?) echo "Invalid option “-$OPTARG”!" >&2 ; exit 2 ;;
			:) echo "Option “-$OPTARG” requires an argument!" >&2 ; exit 3 ;;

			-)
				LONG_OPTARG="${OPTARG#*=}"

				case $OPTARG in
					sync-all) OPT_ALL=1 ;;
					alpha)
						OPT_ALPHA=1
						;;

					bravo=?*)
						OPT_BRAVO="$LONG_OPTARG"
						;;

					charlie)
						OPT_CHARLIE=1
						;;

					sync-dependencies) OPT_DEPENDENCIES=1 ;;

					alpha*|charlie*)
						echo "No argument allowed for the option “--$OPTARG”!" >&2
						exit 4
						;;

					bravo*)
						echo "Option “--$OPTARG” requires an argument!" >&2
						exit 3
						;;

					help) echo "$USAGE" ; exit 0 ;;
					render-readme) OPT_README=1 ;;
					sync-skeleton) OPT_SKELETON=1 ;;
					short-description) echo "$SHORT_DESCRIPTION" ; exit 0 ;;
					test) OPT_TEST=1 ;;
					version) echo "$VERSION" ; exit 0 ;;

					sync-dependencies*|help*|render-readme*|sync-skeleton*|short-description*|test*|version*)
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
