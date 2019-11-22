Test console app designed to show that bundling a .NET exe with mono results in either a binary that cannot be signed or a binary that crashes.

Requirements:
   - Mac OS 10.14.6
   - Visual Studio for Mac 8.3.9
   - XCode 11
   - Mono 6.4.0

Steps to reproduce issue(s)

Case 1:
1. compile the testConsoleAppProduct in VS with release config, produces testConsoleApp.exe
2. in the project folder execute './bundleTestAppWithMono.sh simple' which calls mkbundle with --simple flag
   - https://www.mono-project.com/docs/tools+libraries/tools/mkbundle/ per documentation here
   - produces testConsoleApp binary which works when run on the command line "./bin/Debug/testConsoleApp"

3. in the project folder execute './signTestConsoleApp.sh strict {cert-to-use}', which code signs with --strict -o runtime and entitlements

Expected: signing to be succesful
Actual: signing is unsuccesful


Case 2:
1. compile the testConsoleAppProduct in VS with succesful config, produces testConsoleApp.exe
2. in the project folder execute './bundleTestAppWithMono.sh L' which calls mkbundle with -L and passes mono directory for the path
   - https://www.mono-project.com/docs/tools+libraries/tools/mkbundle/ per documentation here
   - produces testConsoleApp binary which seg faults, error code 11, when run on the command line "./bin/Debug/testConsoleApp"

3. in the project folder execute './signTestConsoleApp.sh strict {cert-to-use}', which code signs with --strict -o runtime and entitlements

Expected: signing to be succesful
Actua: signing is succesful, but the program still seg faults when executed "./bin/Debug/testConsoleApp"

