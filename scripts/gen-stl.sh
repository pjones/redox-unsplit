#!/usr/bin/env bash

set -eu
set -o pipefail

top=$(realpath "$(dirname "$0")/..")

gen_stl() {
  local part=$1
  local side=$2

  openscad \
    --hardwarnings \
    -D "part=\"$part\"" \
    -D "side=\"$side\"" \
    -o "$top/stl/$part-$side.stl" \
    "$top/unsplit.scad"
}

main() {
  for part in plate bottom case mount; do
    for side in left right; do
      gen_stl "$part" "$side"
    done
  done
}

main
