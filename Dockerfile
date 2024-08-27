# Docker file for Rust build-env
FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV CARGO_HOME=/opt/cargo
ENV RUSTUP_HOME=/opt/rustup

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    curl \
    libclang-dev \
    libtss2-dev \
    pkg-config

# Install Rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain=1.80.0 -y

# Start the shell
ENTRYPOINT ["/bin/bash"]
