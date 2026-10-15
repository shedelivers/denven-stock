# denvin_stock

Flutter stock / inventory app (Android + iOS).

## Run on this Mac

Flutter lives at `~/develop/flutter` (not always on your shell `PATH`). Use the helper script:

```bash
./run_android.sh
```

Or set env once, then run:

```bash
export PATH="$HOME/develop/flutter/bin:/opt/homebrew/opt/openjdk@17/bin:$PATH"
export JAVA_HOME="/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home"
export ANDROID_HOME="$HOME/Library/Android/sdk"
export GRADLE_USER_HOME="$HOME/.gradle"

flutter pub get
flutter run
```

Plug in an Android phone with USB debugging, or start an emulator from Android Studio.

Debug APK (after a successful build):

`build/app/outputs/flutter-apk/app-debug.apk`

## Requirements

- Flutter 3.44+ (tested with 3.44.8)
- OpenJDK 17 (`brew install openjdk@17`)
- Android SDK (`~/Library/Android/sdk`)
