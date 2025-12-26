# Let's Dump

# Setup
git config --global user.name "ImSpiDy"
git config --global user.email "SpiDy2713@gmail.com"

# login
echo $gh_token > mytoken.txt # login in github
gh auth login --with-token < mytoken.txt

# Dump folder
DUMP="$(basename "$1" .zip)"

rm -rf $DUMP-dump.zip
zip -r $DUMP-dump.zip $DUMP
gh release create $DUMP --generate-notes --repo https://github.com/ImSpiDy/Dumpyy.git
gh release upload --clobber $DUMP $DUMP-dump.zip --repo https://github.com/ImSpiDy/Dumpyy.git

# upload dump
cd $DUMP

git init
git add .
git commit -m "Import $DUMP"

git branch -M main
git remote add origin https://github.com/ImSpiDy/Dumpyy.git
git push -u origin main
