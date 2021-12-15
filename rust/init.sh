#!/bin/sh

cd ./rust/
cat ./install-app.sh >> ../input/frame-img-custom.sh

TARGET=aarch64-unknown-linux-musl
cargo build --target=${TARGET} --release
cp ./target/${TARGET}/release/hello_world ../input/hello_world