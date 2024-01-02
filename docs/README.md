# OpenAutoLab Documentation

You can find the [documentation here on GitHub pages](https://kauzerei.github.io/openautolab/).
This file is intended for contributors that want to modify this website!

## Dependencies

The included web-flashing utility is based on [avrgirl-arduino](https://github.com/noopkat/avrgirl-arduino) and [zip.js](https://gildas-lormeau.github.io/zip.js/).
Fetch the included git submodules after cloning this repository before working on the docs.

    git submodule update --init

## Local Build

The docs are built using [mdbook](https://github.com/rust-lang/mdBook).
Get the [latest release from GitHub](https://github.com/rust-lang/mdBook/releases) for a pre-built binary if you want to test changes to the docs locally.

    mdbook serve --open docs

This will open your browser to a local development instance of the docs.
