#!/usr/bin/env bash
#
# login
git config --global user.name "ImSpiDy"
git config --global user.email "SpiDy2713@gmail.com"

echo $gh_token > mytoken.txt # login in github
gh auth login --with-token < mytoken.txt

# github release
TAG=LineageExt-15-4.19

# download tested builds
gh release download $TAG -p 'lineage-22.1-Ext-Community-lavender-Vanilla-20250327-1253.zip' -R https://github.com/ImSpiDy/Test-Builds
gh release download $TAG -p 'lineage-22.1-Ext-Community-lavender-Gapps-20250327-1321.zip' -R https://github.com/ImSpiDy/Test-Builds

# upload release builds
gh release create LosExt-15-4.19 --generate-notes --repo https://github.com/ImSpiDy/build-release
gh release upload --clobber LosExt-15-4.19 *.zip --repo https://github.com/ImSpiDy/build-release
