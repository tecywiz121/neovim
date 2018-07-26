Neovim Configuration
====================

## Introduction

This repository contains my personal neovim configuration. It might not be
exactly what you like, but hopefully it's a good starting place for you.

## Installation

Simply run `install.sh` in the root of the repository. The script will create
the correct symbolic links, and download the required submodules. You'll also
have to compile YouCompleteMe.

To fix the incorrect characters in the airline status bar, you'll have to
choose, download, and install a font from the [powerline font][0] repository.
After you've done all that, select the newly installed font in your terminal
emulator and your weird characters should disappear.

[0]: https://github.com/powerline/fonts


### Language Servers

Each language server has to be set up externally to neovim. Double check
`init.vim`, but the currently enabled servers are:

    * Python: https://github.com/palantir/python-language-server
    * Rust: `rustup component add rls-preview rust-analysis rust-src`
