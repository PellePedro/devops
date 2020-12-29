#!/bin/bash
rm -rf $HOME/.cargo
curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain stable
echo "export RUST_DEFAULT_TOOLCHAIN='stable'" >> ~/.profile
. ~/.profile
# Install cargo file watcher
~/.cargo/bin/cargo install cargo-watch

# required for goto source to work with the standard library
rustup component add rls rust-analysis rust-src rustfmt --toolchain stable
