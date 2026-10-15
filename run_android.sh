#!/usr/bin/env bash
# Local Android run helper for macOS.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
export PATH="${HOME}/develop/flutter/bin:/opt/homebrew/opt/openjdk@17/bin:${PATH}"
export JAVA_HOME="/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home"
export ANDROID_HOME="${HOME}/Library/Android/sdk"
export ANDROID_SDK_ROOT="${ANDROID_HOME}"
export GRADLE_USER_HOME="${HOME}/.gradle"
export PATH="${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/cmdline-tools/latest/bin:${PATH}"

cd "$ROOT"

if [[ ! -x "${HOME}/develop/flutter/bin/flutter" ]]; then
  echo "Flutter not found at ~/develop/flutter. Update PATH in this script."
  exit 1
fi

flutter pub get
flutter devices
exec flutter run "$@"
