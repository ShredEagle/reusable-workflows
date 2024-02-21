#!/usr/bin/env bash

# Exit on first error
set -e


##
## Check different preconditions
##

# Check there is one argument
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 version_number" >&2
    exit 1
fi

# Not starting with 'v'
if [[ "$1" == v* ]]; then
    echo "Version number should not start with 'v'" >&2
    exit 1
fi

# Check if the repository is clean (ignoring untracked)
# see: https://unix.stackexchange.com/a/394674
git diff-index --quiet HEAD

# Check the repository is on develop
if [ "$(git rev-parse --abbrev-ref HEAD)" != "develop" ]; then
    echo "Should be on branch 'develop', but currently on '$(git rev-parse --abbrev-ref HEAD)'."
    exit 1
fi


##
## Publish new version with tag
##
git switch main
git pull

git merge develop --no-ff
git tag -a v$1 -m "version $1"
git push origin v$1
git push origin main

git switch develop
