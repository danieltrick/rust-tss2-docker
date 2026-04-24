# Rust version
FROM rust:1.95.0-trixie@sha256:e4f09e8fe5a2366e7d3dc35e08bd25821151e3ed8fdbd3a6a16b51555f0c551d

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
