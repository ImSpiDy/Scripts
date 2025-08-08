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

# release
SFG=1
GHR=1
DL_TAG=infinity-16-4.19
UP_TAG=Infinity-16-4.19
VANILLA=axion-1.6-FINAL-20250721-COMMUNITY-VANILLA-lavender.zip
GAPPS=Project_Infinity-X-3.0-lavender-20250807-0615-GAPPS-UNOFFICIAL.zip

# download tested builds
#gh release download $DL_TAG -p $VANILLA -R https://github.com/ImSpiDy/Test-Builds
gh release download $DL_TAG -p $GAPPS -R https://github.com/ImSpiDy/Test-Builds

if [ $SFG == 1 ]; then
        if [ -f $VANILLA ]; then
                scp -i mysfgtoken.txt $VANILLA imspidy@frs.sourceforge.net:/home/frs/p/spidybuilds/lavender/Axion-15/Vanilla/
        fi
        if [ -f $GAPPS ]; then
                scp -i mysfgtoken.txt $GAPPS imspidy@frs.sourceforge.net:/home/frs/p/spidybuilds/lavender/Infinity-X-16/Gapps/
        fi
fi
if [ $GHR == 1 ]; then
        # upload release builds
        gh release create $UP_TAG --generate-notes --repo https://github.com/ImSpiDy/build-release
        gh release upload --clobber $UP_TAG *.zip --repo https://github.com/ImSpiDy/build-release
fi
