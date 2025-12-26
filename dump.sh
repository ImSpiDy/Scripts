#!/usr/bin/env bash
#
# Script to run Dumpyara (sebaubuntu)
#

if [ -z "$1" ]; then
    echo "Dump: Download link is missing, Please Enter link"
    read -p " " $1
fi

function check () {
    if [ ! -f $1 ]; then $2; fi
}

# Dump folder
DUMP="$(basename "$1" .zip)"

# Install Dumpyara
if command -v pipx >/dev/null 2>&1; then pipx install dumpyara; else pip3 install dumpyara; fi

# Download & Setup Deps
check dump_deps.zip "time wget -q https://github.com/ImSpiDy/Scripts/releases/download/dump_deps/dump_deps.zip
unzip -o dump_deps.zip
mv dump_deps/* $HOME/.local/bin"

export PATH="$HOME/.local/bin:$PATH"

# Download zip
check $DUMP.zip "time wget $1"

# Dump zip
check $DUMP "dumpyara $DUMP.zip"

# Clean Junks
if [ -z "$2" ] && [ $2 = "--up" ]; then
    bash <(curl -s https://raw.githubusercontent.com/ImSpiDy/Scripts/main/dump-up.sh) $1
fi
