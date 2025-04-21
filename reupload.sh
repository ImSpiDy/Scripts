#!/usr/bin/env bash
#
# login
git config --global user.name "ImSpiDy"
git config --global user.email "SpiDy2713@gmail.com"

echo $gh_token > mytoken.txt # login in github
gh auth login --with-token < mytoken.txt

# release
SFG=1
GHR=1
DL_TAG=infinity-15-4.19
UP_TAG=InfinityX-15-4.19
VANILLA=Project_Infinity-X-2.8-lavender-20250509-1038-VANILLA-OFFICIAL.zip
GAPPS=Project_Infinity-X-2.8-lavender-20250509-1226-GAPPS-OFFICIAL.zip

# download tested builds
gh release download $DL_TAG -p $VANILLA -R https://github.com/ImSpiDy/Test-Builds
gh release download $DL_TAG -p $GAPPS -R https://github.com/ImSpiDy/Test-Builds

if [ $SFG == 1 ]; then
        if [ -f *VANILLA* ]; then
                scp *VANILLA*.zip imspidy@frs.sourceforge.net:/home/frs/p/infinity-x/lavender/15/vanilla/
        fi
        if [ -f *GAPPS* ]; then
                scp *GAPPS*.zip imspidy@frs.sourceforge.net:/home/frs/p/infinity-x/lavender/15/gapps/
        fi
fi
if [ $GHR == 1 ]; then
        # upload release builds
        gh release create $UP_TAG --generate-notes --repo https://github.com/ImSpiDy/build-release
        gh release upload --clobber $UP_TAG *.zip --repo https://github.com/ImSpiDy/build-release
fi
