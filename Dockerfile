# Docker file for Rust build-env with libtss2
FROM debian:bookworm-20240812-slim

# Rust version
ARG RUST_VERSION=1.80.0

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update \
    && apt-get install -y \
       curl \
       gcc \
       libclang-dev \
       libtss2-dev \
       pkg-config \
    && apt-get clean -y

# Install Rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain=${RUST_VERSION} -y

# Start the shell
ENTRYPOINT ["/bin/bash", "-l"]
