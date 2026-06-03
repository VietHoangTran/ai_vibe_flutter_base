#!/usr/bin/env sh
set -eu

# Generates Android & iOS launcher icons from assets/images/icon_app_launcher.png.
# To change the app icon: replace that file (keep the same name, 1024x1024),
# then re-run this script.

flutter pub get
dart run flutter_launcher_icons
