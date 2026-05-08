#!/usr/bin/env bash
# Vercel installs Flutter on the Linux build image, then builds web output to build/web.
set -eo pipefail

export PATH="${HOME}/flutter/bin:${PATH}"

if [[ ! -x "${HOME}/flutter/bin/flutter" ]]; then
  echo "Cloning Flutter (stable)..."
  rm -rf "${HOME}/flutter"
  git clone https://github.com/flutter/flutter.git -b stable --depth 1 "${HOME}/flutter"
fi

flutter --version
flutter config --no-analytics
flutter precache --web
flutter pub get
flutter build web --release --no-wasm-dry-run
