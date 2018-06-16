[![Build Status](https://travis-ci.org/Josef-Friedrich/nsupdate-wrapper.sh.svg?branch=master)](https://travis-ci.org/Josef-Friedrich/nsupdate-wrapper.sh)

# nsupdate-wrapper


## Summary / Short description

> Wrapper around nsupdate. Update your DNS server using nsupdate. Supports both ipv4 and ipv6.

## Usage

```
nsupdate-wrapper.sh v1.0

Usage: nsupdate-wrapper.sh [-46dhklnrstvz]

Wrapper around nsupdate. Update your DNS server using nsupdate. Supports both ipv4 and ipv6.

Options:
	-4, --ipv4-only
	  Update the ipv4 / A record only.
	-6, --ipv6-only
	  Update the ipv6 / AAAA record only.
	-d, --device
	  The interface (device to look for an IP address), e. g. “eth0”
	-h, --help
	  Show this help message.
	-k, --key-file
	  Path to private key.
	-l, --literal-key [hmac:]keyname:secret
	  Literal TSIG authentication key. keyname is the name of the
	  key, and secret is the base64 encoded shared secret. hmac is
	  the name of the key algorithm; valid choices are hmac-md5,
	  hmac-sha1, hmac-sha224, hmac-sha256, hmac-sha384, or
	  hmac-sha512. If hmac is not specified, the default is
	  hmac-md5. For example: hmac-sha256:example.com:n+WgaHX...0ni+HOQew8=
	-n, --nameserver
	  DNS server to send updates to, e. g. “ns.example.com”
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

```

## Project pages

* https://github.com/Josef-Friedrich/nsupdate-wrapper.sh

## Testing

```
make test
```

## TODO

* Use more external urls get ip
