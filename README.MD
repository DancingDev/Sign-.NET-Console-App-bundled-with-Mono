Test console app designed to show that bundling a .NET exe with mono results in either a binary that cannot be signed or a binary that crashes.

Related bug, cannot find any other references to this issue on mono github / stack overflow / xamarin community forums
https://xamarin.github.io/bugzilla-archives/52/52443/bug.html

Requirements:
   - Mac OS 10.14.6
   - Visual Studio for Mac 8.3.9
   - XCode 11
   - Mono 6.4.0
   - A Signing Certificate (self signed used below)

Steps to reproduce issue(s)

Case 1:
1. compile the testConsoleAppProduct in VS with release config, produces testConsoleApp.exe
2. in the project folder execute './bundleTestAppWithMono.sh simple' which calls mkbundle with --simple flag
   - https://www.mono-project.com/docs/tools+libraries/tools/mkbundle/ per documentation here
   - produces testConsoleApp binary which works when run on the command line "./bin/Debug/testConsoleApp"

3. in the project folder execute './signTestConsoleApp.sh strict {cert-to-use}', which code signs with --strict -o runtime and entitlements

Expected: signing to be succesful

Actual: signing is unsuccesful, 'testConsoleApp: main executable failed strict validation'


Case 2:
1. compile the testConsoleAppProduct in VS with succesful config, produces testConsoleApp.exe
2. in the project folder execute './bundleTestAppWithMono.sh L' which calls mkbundle with -L and passes mono directory for the path
   - https://www.mono-project.com/docs/tools+libraries/tools/mkbundle/ per documentation here
   - produces testConsoleApp binary which seg faults, error code 11, when run on the command line "./bin/Debug/testConsoleApp"

3. in the project folder execute './signTestConsoleApp.sh strict {cert-to-use}', which code signs with --strict -o runtime and entitlements

Expected: signing to be succesful

Actual: signing is succesful, but the program still seg faults when executed "./bin/Debug/testConsoleApp"



Note: the entitlements being used in entitlements.plist, which most likely are not neccessary, but came from discussions similar to https://github.com/MonoGame/MonoGame/issues/6816 . The disabling of library validation was neccessary due to the dynmamic library importing being blocked due to the signing not being trusted.
    <key>com.apple.security.cs.allow-jit</key>
    <true/>
    <key>com.apple.security.cs.allow-unsigned-executable-memory</key>
    <true/>
    <key>com.apple.security.cs.disable-executable-page-protection</key>
    <true/>
    <key>com.apple.security.cs.disable-library-validation</key>
    <true/>
    <key>com.apple.security.cs.allow-dyld-environment-variables</key>
    <true/>
