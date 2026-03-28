#!/usr/bin/env bash
#
# login
git config --global user.name "ImSpiDy"
git config --global user.email "SpiDy2713@gmail.com"

echo $gh_token > mytoken.txt # login in github
gh auth login --with-token < mytoken.txt

# links
VANILLA=https://github.com/Los-Ext/Test/releases/download/LosExt-16/lineage-23.1-Ext-Community-miatoll-Vanilla-20260217-2235.zip
TAG=LosExt-16-QPR1-Feb

VANILLA=$(basename "$VANILLA")

# download tested builds
gh release download LosExt-16 -p $VANILLA -R https://github.com/Los-Ext/Test

# upload release builds
gh release create $TAG --generate-notes --repo https://github.com/reaPeR1010/build_releases
gh release upload --clobber $TAG *.zip --repo https://github.com/reaPeR1010/build_releases
