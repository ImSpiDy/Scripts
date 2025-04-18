#!/usr/bin/env bash
#
# Upload Files
#

echo " "
echo "[1] Github Release [gh auth login]
[2] Devuploads [Key]
[3] pixeldrain [Key]
[4] Temp.sh
[5] Gofile
[6] oshi.at
[7] Sourceforge [Key]
"
read -p "Please enter your number: " UP
read -p "Please enter file path/name: " FP

read_secret() {
   echo -n "$1"; KEY=""; while IFS= read -r -s -n1 c; do [[ $c == $'\n' || $c == $'\0' ]] && echo && break; [[ $c == $'\177' ]] && KEY="${KEY%?}" && echo -ne "\b \b" || { KEY+="$c"; echo -n "*"; }; done
 }

if [ $UP == 1 ]; then
read -p "Please enter github repo link: " GH
FN="$(basename $FP)" && FN="${FN%%.*}"
echo -e "Started uploading file on github..."
gh release create $FN --generate-notes --repo $GH
gh release upload --clobber $FN $FP --repo $GH
fi

if [ $UP == 2 ]; then
read_secret "Please enter devupload key: "
echo "Started uploading file on DevUploads..."
bash <(curl -s https://devuploads.com/upload.sh) -f $FP -k "$KEY"
fi

if [ $UP == 3 ]; then
read_secret "Please enter Pixel Drain key: "
echo "Started uploading file on PixelDrain..."
curl -T $FP -u ":$KEY" https://pixeldrain.com/api/file/
fi

if [ $UP == 4 ]; then
echo -e "Started uploading file on Temp..."
curl -T $FP temp.sh
fi

if [ $UP == 5 ]; then
echo -e "Started uploading file on Gofile..."
SERVER=$(curl -X GET 'https://api.gofile.io/servers' | grep -Po '(store*)[^"]*' | tail -n 1)
curl -X POST https://${SERVER}.gofile.io/contents/uploadfile -F "file=@$FP" | grep -Po '(https://gofile.io/d/)[^"]*'
fi

if [ $UP == 6 ]; then
echo -e "Started uploading file on Oshi.at..."
curl -T $FP https://oshi.at
fi

if [ $UP == 7 ]; then
echo -e "Started uploading file on Sourceforge..."
read -p "Please enter Username: " USER
read -p "Please enter upload location:
Note: Path after /home/frs/project/" UPL
scp $FP "$USER"@frs.sourceforge.net:/home/frs/project/$UPL
fi
