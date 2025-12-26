# Let's Dump

# Download zip
time aria2c $1 -x16 -s50

# Install Dumpyara (use pipx to fix PEP 668)
pipx install dumpyara

# Install deps
apt install erofs-utils android-sdk-libsparse-utils

export PATH="$HOME/.local/bin:$PATH"

$HOME/.local/bin/dumpyara *zip

# Dump it
$HOME/.local/bin/dumpyara *zip
