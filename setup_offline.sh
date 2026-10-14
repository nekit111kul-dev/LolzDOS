#!/bin/sh
# Optional: copy js-dos into ./jsdos so the project works without the CDN.
# Needs Node.js/npm and internet access once.
set -e
cd "$(dirname "$0")"
tmp=$(mktemp -d)
( cd "$tmp" && npm init -y >/dev/null && npm install js-dos )
cp -r "$tmp"/node_modules/js-dos/dist/* jsdos/
rm -rf "$tmp"
echo "js-dos copied to ./jsdos (check that jsdos/js-dos.js and jsdos/emulators/ exist)"
