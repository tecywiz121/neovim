#!/bin/bash
set -euf -o pipefail

symlink() {
    local TARGET="$1"
    local LINK_NAME="$2"

    local REAL_TARGET="$(readlink -f -n "$TARGET")"

    if ! [ -h "$LINK_NAME" -a "$(readlink -f -n "$LINK_NAME")" = "$REAL_TARGET" ]; then
        ln -s "$TARGET" "$LINK_NAME"
    fi
}

# Change into the directory the script is located in to make things easier
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Download all the required submodules for the plugins.
git submodule update --init --recursive

# Create symbolic links to the nvim configuration folders.
symlink "$SCRIPT_DIR/config" "${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
symlink "$SCRIPT_DIR/share"  "${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site"
