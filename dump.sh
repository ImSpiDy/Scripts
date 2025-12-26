# Let's Dump

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
rm -rf $DUMP/boot $DUMP/modem
find $DUMP -type f -name "*.apk" -size +50M -print -delete

if [ -z "$1" ] && [ $2 = "--up" ]; then
    check dump-up.sh "wget -q https://raw.githubusercontent.com/ImSpiDy/Scripts/refs/heads/main/dump-up.sh
    bash dump-up.sh $1"
fi
