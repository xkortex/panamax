#!/usr/bin/env bash
## This will inject sccache into the system and create hooks
## Currently this is root-only, for containers

OSNAME=$(uname  | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -p)

errcho() {
    (>&2 echo -e "\e[31m$1\e[0m")
}

check_dep() {
    command -v ${1} >/dev/null 2>&1 || { errcho "Script requires '${1}' but it's not installed. Aborting."; exit 1; }
}

check_dep wget

if [[ -z "$SCCACHE_REDIS" ]]; then
    errcho "Variable 'SCCACHE_REDIS' must be set"
    exit 1
fi

## https://stackoverflow.com/questions/2497215/how-to-extract-domain-name-from-url
## I have no idea how it works
## Extract host in separate step because it is a bit safer and easier to debug
_SCCACHE_HOST=$(echo $SCCACHE_REDIS | sed -e "s/[^/]*\/\/\([^@]*@\)\?\([^:/]*\).*/\2/" )
_SCCACHE_HOSTPORT=$(echo "$SCCACHE_REDIS" | sed -e "s/[^/]*\/\/\([^@]*@\)\?\([^/]*\).*/\2/" )
_SCCACHE_PORT=$(echo "${_SCCACHE_HOSTPORT}" | grep -Po -e '(?<=:)(\d+$)')



if [[ -z "$_SCCACHE_HOST" ]] || [[ -z "$_SCCACHE_PORT" ]]; then
    errcho "Variable 'SCCACHE_REDIS' must be of format 'redis://[:<passwd>@]<hostname>[:port][/<db>]'"
fi

## download and enable sccache
wget --no-check-certificate -qO- \
    "https://github.com/mozilla/sccache/releases/download/0.2.8/sccache-0.2.8-${ARCH}-unknown-${OSNAME}-musl.tar.gz" \
        | tar xvz \
    && mv "sccache-0.2.8-${ARCH}-unknown-${OSNAME}-musl/sccache" /usr/local/bin/sccache \
    && rm -r "sccache-0.2.8-${ARCH}-unknown-${OSNAME}-musl/" \
    && chmod +x /usr/local/bin/sccache

## Check if server is reachable
sccache -s
status=$?
if [[ $status -ne 0 ]]; then
    errcho "Failed to contact sccache server at ${_SCCACHE_HOST}:${_SCCACHE_PORT}"
    exit 1
fi


SCC_DIR=/usr/local/bin/sccache.d
mkdir -p "${SCC_DIR}"

printf '#!/bin/bash
## Wrap our compiler with sccache to allow setting CC=/path/to/sccache.d/gxx
exec sccache /usr/bin/gcc "$@"
' > "$SCC_DIR/gcc"

printf '#!/bin/bash
## Wrap our compiler with sccache to allow setting CC=/path/to/sccache.d/gxx
exec sccache /usr/bin/g++ "$@"
' > "$SCC_DIR/g++"

chmod +x "$SCC_DIR/gcc"
chmod +x "$SCC_DIR/g++"

export CC="$SCC_DIR/gcc"
export CXX="$SCC_DIR/g++"

