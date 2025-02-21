#!/usr/bin/env sh
nix flake update
nix run nix-darwin -- switch --flake ~/dts
doom upgrade
