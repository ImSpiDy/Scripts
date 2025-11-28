#!/usr/bin/env bash
#
# login
git config --global user.name "ImSpiDy"
git config --global user.email "SpiDy2713@gmail.com"

echo $gh_token > mytoken.txt # login in github
gh auth login --with-token < mytoken.txt

# login sfg (circle ci variable isn't working as intend"
echo "-----BEGIN OPENSSH PRIVATE KEY-----" > mysfgtoken.txt
echo $SFG1 >> mysfgtoken.txt
echo $SFG2 >> mysfgtoken.txt
echo $SFG3 >> mysfgtoken.txt
echo $SFG4 >> mysfgtoken.txt
echo $SFG5 >> mysfgtoken.txt
echo "-----END OPENSSH PRIVATE KEY-----" >> mysfgtoken.txt
chmod 600 mysfgtoken.txt
ssh-keyscan frs.sourceforge.net >> ~/.ssh/known_hosts

# site # Infinity-X-16 # Yaap-16 #LosExt-16
SFG=1
SFG_TAG=LosExt-16
GHR=1

# links
VANILLA=https://github.com/ImSpiDy/Test-Builds/releases/download/LineageExt-16-4.19/lineage-23.0-Ext-Community-lavender-Vanilla-20251128-1505.zip
GAPPS=https://github.com/ImSpiDy/Test-Builds/releases/download/LineageExt-16-4.19/lineage-23.0-Ext-Community-lavender-Gapps-20251128-1518.zip

if [ ! $VANILLA ]; then
TAG=$(basename "$(dirname "$GAPPS")")
else
TAG=$(basename "$(dirname "$VANILLA")")
fi

VANILLA=$(basename "$VANILLA")
GAPPS=$(basename "$GAPPS")

# download tested builds
gh release download $TAG -p $VANILLA -R https://github.com/ImSpiDy/Test-Builds
gh release download $TAG -p $GAPPS -R https://github.com/ImSpiDy/Test-Builds

if [ $SFG == 1 ]; then
        if [ -f $VANILLA ]; then
                scp -i mysfgtoken.txt $VANILLA imspidy@frs.sourceforge.net:/home/frs/p/spidybuilds/lavender/$SFG_TAG/Vanilla/
        fi
        if [ -f $GAPPS ]; then
                scp -i mysfgtoken.txt $GAPPS imspidy@frs.sourceforge.net:/home/frs/p/spidybuilds/lavender/$SFG_TAG/Gapps/
        fi
fi
if [ $GHR == 1 ]; then
	TAG="$(tr '[:lower:]' '[:upper:]' <<< ${TAG:0:1})${TAG:1}"
        # upload release builds
        gh release create $TAG --generate-notes --repo https://github.com/ImSpiDy/build-release
        gh release upload --clobber $TAG *.zip --repo https://github.com/ImSpiDy/build-release
fi
