#!/usr/bin/env bash
# Vercel installs Flutter on the Linux build image, then builds web output to build/web.
set -euo pipefail

export PATH="${HOME}/flutter/bin:${PATH}"

if [[ ! -x "${HOME}/flutter/bin/flutter" ]]; then
  echo "Cloning Flutter (stable)..."
  git clone https://github.com/flutter/flutter.git -b stable --depth 1 "${HOME}/flutter"
fi

flutter --version
flutter config --no-analytics
flutter doctor -v
flutter pub get
flutter build web --release --no-wasm-dry-run
