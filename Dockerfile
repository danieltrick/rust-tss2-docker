# Rust version
FROM rust:1.94.1-trixie@sha256:f2a0f2b3529c9bbbf5479d131611451a3cc3956d9a11374d6d4ba96f059c1dce

# Set up environment
ENV CARGO_HOME="/usr/local/cargo"
ENV RUSTUP_HOME="/usr/local/rustup"
ENV CARGO_TARGET_DIR=/var/tmp/rust/target

# Provide the 'install_packages' helper script
COPY bin/install_packages.sh /usr/sbin/install_packages

# Install runtime dependencies
RUN install_packages \
    ca-certificates \
    gcc \
    libclang-dev \
    libcurl4-openssl-dev \
    libjson-c-dev \
    libssl-dev \
    libtss2-dev \
    pkg-config \
    uuid-dev

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
