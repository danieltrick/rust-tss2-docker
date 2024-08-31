#!/bin/bash
. "${CARGO_HOME}/env"
set -x
cargo "${@:-build}"
