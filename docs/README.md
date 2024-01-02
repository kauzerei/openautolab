# OpenAutoLab Documentation

The docs are built using [mdbook](https://github.com/rust-lang/mdBook).
Get the [latest release from GitHub](https://github.com/rust-lang/mdBook/releases) for a pre-built binary if you want to test changes to the docs locally.

    mdbook serve --open docs

The included web-flashing utility is based on [avrgirl-arduino](https://github.com/noopkat/avrgirl-arduino) and [zip.js](https://gildas-lormeau.github.io/zip.js/).
Fetch the included git submodules after cloning this repository before working on the docs.

    git submodule update --init
