#!/bin/sh
set -e

echo "---"
if [ -z "${GIT_COMMIT}" ]; then
	echo "Error: Commit sha not specified"
else
	echo "We're on commit ${GIT_COMMIT}"
fi
echo "We're on tag ${GIT_TAG:-untagged}"
echo "---"
