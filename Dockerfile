# Rust version
FROM rustlang/rust:nightly-trixie-2026-11-13@sha256:1b756ba7156fa53983f942a0038b8680ee921219ce7fe1be7a480be1b373230e

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
    nodejs \
    pkgconf \
    uuid-dev

# Build libtss2
RUN git clone --branch master --single-branch https://github.com/tpm2-software/tpm2-tss.git /tmp/tpm2-tss-build && \
    cd /tmp/tpm2-tss-build && \
    git checkout -B master d21de645c1a8a2ffadbe6186db2b0fdb8a19eb00 && \
    ./bootstrap && \
    ./configure --disable-doxygen-doc && \
    make -j$(nproc) && \
    make -j$(nproc) install && \
    cd / && \
    rm -rf /tmp/tpm2-tss-build && \
    ldconfig

# Install Rust components
RUN rustup component add rustfmt && \
    rustup component add clippy

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
