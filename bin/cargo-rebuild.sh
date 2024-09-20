#!/bin/bash -ex
cargo clean
cargo build "${@:2}"
