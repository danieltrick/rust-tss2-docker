# Debian Version
FROM debian:trixie-20260713-slim

# Set up environment
ENV CARGO_HOME="/usr/local/cargo"
ENV RUSTUP_HOME="/usr/local/rustup"
ENV CARGO_TARGET_DIR=/var/tmp/rust/target

# Provide the 'install_packages' helper script
COPY bin/install_packages.sh /usr/sbin/install_packages

# Install runtime dependencies
RUN install_packages \
    autoconf \
    autoconf-archive \
    automake \
    build-essential \
    ca-certificates \
    cmake \
    curl \
    git \
    libclang-dev \
    libcurl4-openssl-dev \
    libjson-c-dev \
    libltdl-dev \
    libssl-dev \
    libtool \
    pkgconf \
    uuid-dev

# Build libtss2
RUN git clone --branch master --single-branch https://github.com/tpm2-software/tpm2-tss.git /tmp/tpm2-tss-build && \
    cd /tmp/tpm2-tss-build && \
    git checkout -B master 506c5e6db0c8514f321dc16a0da2580483f3df04 && \
    ./bootstrap && \
    ./configure --disable-doxygen-doc && \
    make -j$(nproc) && \
    make -j$(nproc) install && \
    cd / && \
    rm -rf /tmp/tpm2-tss-build && \
    ldconfig

# Install Rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain=nightly-2026-07-30 --profile=minimal -y && \
    ${CARGO_HOME}/bin/rustup component add rustfmt && \
    ${CARGO_HOME}/bin/rustup component add clippy

# Copy 'rebuild' command
COPY bin/cargo-rebuild.sh /usr/local/cargo/bin/cargo-rebuild

# Copy entry-point script
COPY bin/entry-point.sh /opt/rust/entry-point.sh

# Copy example project
COPY src/example/ /var/opt/rust/src/

# Working directory
WORKDIR /var/opt/rust/src

# Entry point
ENTRYPOINT ["/opt/rust/entry-point.sh"]
