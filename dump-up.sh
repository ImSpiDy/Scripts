# Let's Dump

# Setup
git config --global user.name "ImSpiDy"
git config --global user.email "SpiDy2713@gmail.com"

# login
echo $gh_token > mytoken.txt # login in github
gh auth login --with-token < mytoken.txt
gh auth status

# Dump folder
DUMP="$(basename "$1" .zip)"

# upload dump
cd $DUMP

# Nuke junks folders
find . -type d -name bin -exec rm -rf {} +
find . -type d -name fonts -exec rm -rf {} +
find . -type d -name framework -exec rm -rf {} +
find . -type d -name modem -exec rm -rf {} +
find . -type d -name security -exec rm -rf {} +
find . -type d -name vndk-28 -exec rm -rf {} +
find . -type d -name vintf -exec rm -rf {} +

# Nuke junk files
find . -name "*.apk" -delete
find . -name "*.vdex" -delete
find . -name "*.odex" -delete
find . -name "*.jpg" -delete
find . -name "*.png" -delete
find . -name "*.zip" -delete

cd -

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
