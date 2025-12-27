# Let's Dump

# Dump folder
DUMP="$(basename "$1" .zip)"

# Install Dumpyara
pipx install dumpyara

# Download files
DEPS=https://github.com/ImSpiDy/Scripts/releases/download/dump_deps/dump_deps.zip
time aria2c $DEPS -x16 -s50
time aria2c $1 -x16 -s50

# Setup Deps
unzip -o dump_deps.zip
mv dump_deps/* $HOME/.local/bin
export PATH="$HOME/.local/bin:$PATH"

# Dump it
dumpyara $DUMP.zip

if [ $2 = "--up" ]; then
wget https://raw.githubusercontent.com/ImSpiDy/Scripts/refs/heads/main/dump-up.sh
bash dump-up.sh $1
fi
