#!/bin/bash

# add Mono's bin directory to PATH
MONOROOT="/Library/Frameworks/Mono.framework"
export PATH="$PATH:$MONOROOT/Commands"

## print out current mono versions
ls $MONOROOT/Versions
$MONOROOT/Versions/Current/bin/mono -V
pushd $MONOROOT/Versions/Current
MONOVERSIONPATH=($(pwd -P))
popd
echo "MONOVERSIONSPATH: $MONOVERSIONPATH"

##################################################
# Configure Mono Versions                        #
##################################################

echo ""
echo "Configuring mono version check... "

REQUIRED_MONO_VERSION="6.4.0"

# save away the current symlink (it might be an absolute path)
SAVED_MONO_SYMLINK=$(readlink $MONOROOT/Versions/Current)

# find the latest version of Mono
LATEST_MONO_VERSION=$(ls $MONOROOT/Versions/ | grep [d.d.d] | tail -1)
echo Lastest Mono version is $LATEST_MONO_VERSION

# now check that we have the right version of Mono
MONO_VERSION="$(mono --version | grep 'Mono JIT compiler version ' |  cut -f5 -d\ | cut -c1-5)"
if [ -z "$MONO_VERSION" ] || [ $MONO_VERSION != $REQUIRED_MONO_VERSION ]
then
  # point Current to the version we want (5.8.0)
  sudo ln -Ffhs $REQUIRED_MONO_VERSION $MONOROOT/Versions/Current
fi

# now check that we have the right version of Mono
MONO_VERSION="$(mono --version | grep 'Mono JIT compiler version ' |  cut -f5 -d\ | cut -c1-5)"

if [ -z "$MONO_VERSION" ] || [ $MONO_VERSION != $REQUIRED_MONO_VERSION ]
then
	echo "This machine does not have the $REQUIRED_MONO_VERSION version of Mono installed. Found $MONO_VERSION"
	echo "Configuring Mono failed"
	echo ""
  # restore Mono Current symlink
  sudo ln -Ffhs $SAVED_MONO_SYMLINK $MONOROOT/Versions/Current
	exit 1
fi

echo "Mono Configuration Complete"
echo ""

##################################################
# Mono Configuration Complete                    #
##################################################

pushd bin/Debug

rm -rf testConsoleApp

if [ "$1" = simple ]; then
  echo calling "mkbundle -v -o testConsoleApp --deps --simple testConsoleApp.exe --sdk $MONOROOT/Versions/Current"
  mkbundle -v -o testConsoleApp --deps --simple testConsoleApp.exe \
                               --sdk $MONOROOT/Versions/Current
elif [ "$1" = L ]; then
  echo calling "mkbundle -v -o testConsoleApp --deps testConsoleApp.exe -L $MONOROOT/Versions/Current/lib/mono/4.5/"
  mkbundle -v -o testConsoleApp --deps testConsoleApp.exe -L $MONOROOT/Versions/Current/lib/mono/4.5/

elif [ "$1" = sdk ]; then
  echo calling "mkbundle -v -o testConsoleApp --deps testConsoleApp.exe --sdk $MONOROOT/Versions/Current"
  mkbundle -v -o testConsoleApp --deps testConsoleApp.exe --sdk $MONOROOT/Versions/Current

elif [ "$1" = static ]; then
  echo calling "mkbundle -v -o testConsoleApp --deps testConsoleApp.exe --static --sdk $MONOROOT/Versions/Current"
  mkbundle -v -o testConsoleApp testConsoleApp.exe -static
fi

popd

exit 0
