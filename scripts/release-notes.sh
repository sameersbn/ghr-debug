#!/usr/bin/env sh

RELEASE=${GIT_TAG:-$1}

if [ -z "${RELEASE}" ]; then
	echo "Usage:"
	echo "./scripts/release-notes.sh v0.1.0"
	exit 1
fi

if ! git rev-list ${RELEASE} >/dev/null 2>&1; then
	echo "${RELEASE} does not exist"
	exit
fi

PREV_RELEASE=${PREV_RELEASE:-$(git describe --always --tags --abbrev=0 ${RELEASE}^)}
NOTABLE_CHANGES=$(git cat-file -p ${RELEASE} | sed '/-----BEGIN PGP SIGNATURE-----/,//d' | tail -n +6)
CHANGELOG=$(git log --no-merges --pretty=format:'- [%h] %s (%aN)' ${PREV_RELEASE}..${RELEASE})
if [ $? -ne 0 ]; then
	echo "Error creating changelog"
	exit 1
fi

cat <<EOF
${NOTABLE_CHANGES}

## Installation

Download Shaout ${RELEASE}

- [container](https://gcr.io/cebuk-01/sameer/shaout:${RELEASE})
- [linux/amd64](https://github.com/sameersbn/shaout/releases/download/${RELEASE}/shaout-linux-amd64)
- [macos/amd64](https://github.com/sameersbn/shaout/releases/download/${RELEASE}/shaout-darwin-amd64)
- [windows/amd64](https://github.com/sameersbn/shaout/releases/download/${RELEASE}/shaout-windows-amd64.exe)

## Changelog

${CHANGELOG}
EOF
