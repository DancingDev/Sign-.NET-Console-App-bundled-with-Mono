
pushd bin/Debug

CERT=$2

ENTSFILE=../../entitlements.plist

if [ "$1" = strict ]; then
  codesign -f --strict --verbose --entitlements $ENTSFILE -o runtime -s "$CERT" testConsoleApp --timestamp
elif [ "$1" = no-strict ]; then
  codesign -f --no-strict --verbose --entitlements $ENTSFILE -o runtime -s "$CERT" testConsoleApp --timestamp
elif [ "$1" = simple ]; then
  codesign -f --verbose -s "$CERT" testConsoleApp --timestamp
fi

popd
