#!/usr/bin/env bash
#
# login
git config --global user.name "ImSpiDy"
git config --global user.email "SpiDy2713@gmail.com"

echo $gh_token > mytoken.txt # login in github
gh auth login --with-token < mytoken.txt

# links
VANILLA=https://github.com/pa-xe/builds/releases/download/lineage-23/lineage-23.1-Ext-Community-miatoll-Vanilla-20260205-1713.zip
TAG=LosExt-16-QPR1

VANILLA=$(basename "$VANILLA")

# download tested builds
gh release download lineage-23 -p $VANILLA -R https://github.com/pa-xe/builds/

# upload release builds
gh release create $TAG --generate-notes --repo https://github.com/reaPeR1010/build_releases
gh release upload --clobber $TAG *.zip --repo https://github.com/reaPeR1010/build_releases
