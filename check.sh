#!/bin/bash

# This script handles some basic QA checks on the source

LIBRARY_NAME=`grep -m 1 name pyproject.toml | awk -F" = " '{print substr($2,2,length($2)-2)}'`
LIBRARY_VERSION=`grep __version__ $LIBRARY_NAME/__init__.py | awk -F" = " '{print substr($2,2,length($2)-2)}'`

success() {
	echo -e "$(tput setaf 2)$1$(tput sgr0)"
}

inform() {
	echo -e "$(tput setaf 6)$1$(tput sgr0)"
}

warning() {
	echo -e "$(tput setaf 1)$1$(tput sgr0)"
}

inform "Checking for trailing whitespace..."
grep -IUrn --color "[[:blank:]]$" --exclude-dir=dist --exclude-dir=.tox --exclude-dir=.git --exclude=PKG-INFO
if [[ $? -eq 0 ]]; then
    warning "Trailing whitespace found!"
    exit 1
else
    success "No trailing whitespace found."
fi
printf "\n"

inform "Checking for DOS line-endings..."
grep -lIUrn --color $'\r' --exclude-dir=dist --exclude-dir=.tox --exclude-dir=.git --exclude=Makefile
if [[ $? -eq 0 ]]; then
    warning "DOS line-endings found!"
    exit 1
else
    success "No DOS line-endings found."
fi
printf "\n"

inform "Checking CHANGELOG.md..."
cat CHANGELOG.md | grep ^${LIBRARY_VERSION} > /dev/null 2>&1
if [[ $? -eq 1 ]]; then
    warning "Changes missing for version ${LIBRARY_VERSION}! Please update CHANGELOG.md."
    exit 1
else
    success "Changes found for version ${LIBRARY_VERSION}."
fi
printf "\n"

inform "Checking for git tag ${LIBRARY_VERSION}..."
git tag -l | grep -E "${LIBRARY_VERSION}$"
if [[ $? -eq 1 ]]; then
    warning "Missing git tag for version ${LIBRARY_VERSION}"
fi
printf "\n"