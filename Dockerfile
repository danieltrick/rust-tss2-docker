# Rust version
FROM rustlang/rust:nightly-trixie-2026-10-02@sha256:741c0a96047c0776fc59fc4407fe52cf27c03d8f7981ddd32c6bec189a468e0a

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
    git checkout -B master d50e55b13a968a0c1dc4e127ffe1aa5eb8c3f71c && \
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
