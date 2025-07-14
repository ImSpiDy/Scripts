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
GHR=0
DL_TAG=infinity-15-4.19
UP_TAG=InfinityX-15-4.19
VANILLA=Project_Infinity-X-2.9-lavender-20250712-1758-VANILLA-UNOFFICIAL.zip
GAPPS=Project_Infinity-X-2.9-lavender-20250712-1823-GAPPS-UNOFFICIAL.zip

# download tested builds
gh release download $DL_TAG -p $VANILLA -R https://github.com/ImSpiDy/Test-Builds
gh release download $DL_TAG -p $GAPPS -R https://github.com/ImSpiDy/Test-Builds

if [ $SFG == 1 ]; then
        if [ -f *VANILLA* ]; then
                scp -i mysfgtoken.txt *VANILLA*.zip imspidy@frs.sourceforge.net:/home/frs/p/spidybuilds/lavender/Android-15/Infinity-X/Vanilla/
        fi
        if [ -f *GAPPS* ]; then
                scp -i mysfgtoken.txt *GAPPS*.zip imspidy@frs.sourceforge.net:/home/frs/p/spidybuilds/lavender/Android-15/Infinity-X/Gapps/
        fi
fi
if [ $GHR == 1 ]; then
        # upload release builds
        gh release create $UP_TAG --generate-notes --repo https://github.com/ImSpiDy/build-release
        gh release upload --clobber $UP_TAG *.zip --repo https://github.com/ImSpiDy/build-release
fi
