#!/bin/bash
echo ""

rm -rf bin

MONOROOT="/Library/Frameworks/Mono.framework"
export PATH="$PATH:$MONOROOT/Commands"

ENTSFILE=../../entitlements.plist

CERT=$1

echo "Build testconsoleapp"
sudo msbuild ../testConsoleApp.sln -p:Configuration=Release -p:OutputPath=bin/Release/ -p:AllowUnsafeBlocks=true -maxcpucount:2 -nodeReuse:false -nologo -consoleloggerparameters:Summary

echo "run mkbundle"
pushd bin/Release
mkbundle -v -o testConsoleApp --deps --simple testConsoleApp.exe \
                               --sdk $MONOROOT/Versions/Current

echo "sign app"
codesign -f --strict --verbose --entitlements $ENTSFILE -o runtime -s $CERT testConsoleApp --timestamp
popd

echo "verify app"
bin/Release/testConsoleApp
