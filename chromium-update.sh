#! /bin/bash
# A simple script to download and update the latest Mac build of Chromium.
# Heavily inspired by https://github.com/scheib/chromium-latest-linux written by schieb
echo "Current version:" $(/Applications/Chromium.app/Contents/MacOS/Chromium --version)
mkdir -p /tmp/chromium
cd /tmp/chromium
LASTCHANGE_URL="https://www.googleapis.com/download/storage/v1/b/chromium-browser-snapshots/o/Mac%2FLAST_CHANGE?alt=media"

REVISION=$(curl -s -S $LASTCHANGE_URL)

echo "Latest revision: $REVISION"

if [ -d $REVISION ] ; then
  echo "We already have the latest version locally"
  exit
fi

ZIP_URL="https://www.googleapis.com/download/storage/v1/b/chromium-browser-snapshots/o/Mac%2F$REVISION%2Fchrome-mac.zip?alt=media"

ZIP_FILE="${REVISION}-chrome-mac.zip"

echo "Fetching $ZIP_URL"

rm -rf $REVISION
mkdir $REVISION
#pushd $REVISION
curl -# $ZIP_URL > $ZIP_FILE
echo -n "Unzipping..."
unzip -o $ZIP_FILE | awk 'BEGIN {ORS=""} {print "."}'
echo "done!"
rm $ZIP_FILE
if [ -d /Applications/Chromium.app ] ; then
	rm -rf /Applications/Chromium.app
fi
mv -v chrome-mac/Chromium.app /Applications/
#popd
exit