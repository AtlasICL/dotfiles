#!/usr/bin/env bash

tmp=$(mktemp -d) && curl -sLo "$tmp/whatdidi" https://raw.githubusercontent.com/AtlasICL/whatdidi/main/whatdidi && curl -sLo "$tmp/install" https://raw.githubusercontent.com/AtlasICL/whatdidi/main/install && bash "$tmp/install" && rm -rf "$tmp"
