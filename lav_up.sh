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

vex () {
    curl -X POST https://vexfile.com/api/upload/handle \
      -H "Content-Type: application/json" \
      -d "{
        \"token\": \"$VEX_KEYS\",
        \"url\": \"$1\"
      }"
}

# site # Infinity-X-16 # Yaap-16 #LosExt-16
SFG=0
#SFG_TAG=Infinity-X-16
#SFG_TAG=LosExt-16
SFG_TAG=Yaap-16
GHR=0
DEV=1
VEX=1

# links
VANILLA_URL=https://github.com/ImSpiDy/Test-Builds/releases/download/infinity-16-4.19/Project_Infinity-X-3.12-lavender-07.07.2026-VANILLA-UNOFFICIAL.zip
GAPPS_URL=https://github.com/ImSpiDy/Test-Builds/releases/download/infinity-16-4.19/Project_Infinity-X-3.12-lavender-07.07.2026-GAPPS-UNOFFICIAL.zip

if [ ! $VANILLA_URL ]; then
	TAG=$(basename "$(dirname "$GAPPS_URL")")
else
	TAG=$(basename "$(dirname "$VANILLA_URL")")
fi

VANILLA_ZIP="$(basename "$VANILLA_URL")"
GAPPS_ZIP="$(basename "$GAPPS_URL")"

# download tested builds
gh release download $TAG -p $VANILLA_ZIP -R https://github.com/ImSpiDy/Test-Builds
gh release download $TAG -p $GAPPS_ZIP -R https://github.com/ImSpiDy/Test-Builds

if [ $SFG == 1 ]; then
	if [ -f $VANILLA_ZIP ]; then
		scp -i mysfgtoken.txt $VANILLA_ZIP imspidy@frs.sourceforge.net:/home/frs/p/spidybuilds/lavender/$SFG_TAG/Vanilla/
	fi
	if [ -f $GAPPS_ZIP ]; then
		scp -i mysfgtoken.txt $GAPPS_ZIP imspidy@frs.sourceforge.net:/home/frs/p/spidybuilds/lavender/$SFG_TAG/Gapps/
	fi
fi
if [ $GHR == 1 ]; then
	TAG="$(tr '[:lower:]' '[:upper:]' <<< ${TAG:0:1})${TAG:1}"
	# upload release builds
	gh release create $TAG --generate-notes --repo https://github.com/ImSpiDy/build-release
	gh release upload --clobber $TAG *.zip --repo https://github.com/ImSpiDy/build-release
fi
if [ $DEV == 1 ]; then
	if [ -f $VANILLA_ZIP ]; then
		bash <(curl -s https://devuploads.com/upload.sh) -f $VANILLA_ZIP -k "$DEV_KEYS"
	fi
	if [ -f $GAPPS_ZIP ]; then
		bash <(curl -s https://devuploads.com/upload.sh) -f $GAPPS_ZIP -k "$DEV_KEYS"
	fi
fi
if [ $VEX == 1 ]; then
	TAG=TEMP_UPLOAD
	gh release create $TAG --generate-notes --repo https://github.com/ImSpiDy/build-release
	gh release upload --clobber $TAG *.zip --repo https://github.com/ImSpiDy/build-release
	if [ -f $VANILLA_ZIP ]; then
		vex https://github.com/ImSpiDy/build-release/releases/download/$TAG/$VANILLA_ZIP
	fi
	if [ -f $GAPPS_ZIP ]; then
		vex https://github.com/ImSpiDy/build-release/releases/download/$TAG/$GAPPS_ZIP
	fi
	gh release delete "$TAG" --cleanup-tag --yes -R https://ImSpiDy:$(gh auth token)@github.com/ImSpiDy/build-release
fi
