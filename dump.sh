#!/usr/bin/env bash
#
# Script to run Dumpyara (sebaubuntu)
#

if [ -z "$1" ]; then
    echo
    echo -e "Dump: \e[1;31mDownload link is missing\e[0m, Please Enter link.\n"
    read -p "-> " LINK
    echo
else
    LINK=$1
fi

function check () {
    if [ ! -f $1 ]; then $2; fi
}

# Dump folder
DUMP="$(basename "$LINK" .zip)"

# Install Dumpyara
if command -v pipx >/dev/null 2>&1; then pipx install dumpyara; else pip3 install dumpyara; fi

# Download & Setup Deps
check dump_deps.zip "time wget -q https://github.com/ImSpiDy/Scripts/releases/download/dump_deps/dump_deps.zip
unzip -o dump_deps.zip
mv dump_deps/* $HOME/.local/bin"

export PATH="$HOME/.local/bin:$PATH"

# Download zip
check $DUMP.zip "time wget $LINK"

# Dump zip
check $DUMP "dumpyara $DUMP.zip"

# Upload
if [ -z "$2" ]; then UP=0; else UP=$2; fi
if [ $UP = "--up" ]; then
    bash <(curl -s https://raw.githubusercontent.com/ImSpiDy/Scripts/main/dump-up.sh) $LINK
fi
