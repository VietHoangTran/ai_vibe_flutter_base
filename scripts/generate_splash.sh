#!/usr/bin/env sh
set -eu

# Generates Android & iOS native splash screens from assets/images/splash.png.
# To change the splash: replace that file (keep the same name; a transparent
# PNG works best so the background color shows through), then re-run this script.

flutter pub get
dart run flutter_native_splash:create
