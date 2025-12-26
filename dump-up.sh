# Let's Dump

# Setup
git config --global user.name "ImSpiDy"
git config --global user.email "SpiDy2713@gmail.com"

# login
if ! gh auth switch >/dev/null 2>&1; then
echo $gh_token > mytoken.txt # login in github
gh auth login --with-token < mytoken.txt
fi

# Dump folder
DUMP="$(basename "$1" .zip)"

rm -rf $DUMP-dump.zip
zip -r $DUMP-dump.zip $DUMP
gh release create $DUMP --generate-notes --repo https://github.com/ImSpiDy/Dumpyy.git
gh release upload --clobber $DUMP $DUMP-dump.zip --repo https://github.com/ImSpiDy/Dumpyy.git

# upload dump
cd $DUMP

git init

# Clean Junks
rm -rf boot modem

# Respect Github's file size limit
find $DUMP -type f -name "*.apk" -size +99M -print -delete

git add .
git commit -m "$DUMP"

git branch -M main
git remote add origin https://github.com/ImSpiDy/Dumpyy.git
git push -u origin main
