# Debian Version
FROM debian:sid-20240926-slim@sha256:12f32e3af969bccab48f38553542a6fa0e84103587ace94537dc2430e12c0b14

# Rust version
ARG RUST_VERSION=nightly-2024-09-28

# Set up environment
ENV CARGO_HOME="/usr/local/cargo"
ENV RUSTUP_HOME="/usr/local/rustup"
ENV CARGO_TARGET_DIR=/var/tmp/rust/target

# Provide the 'install_packages' tool
COPY bin/install_packages.sh /usr/sbin/install_packages

# Install runtime dependencies
RUN install_packages \
    ca-certificates \
    curl \
    gcc \
    libclang-dev \
    libtss2-dev \
    pkg-config \
    uuid-dev

# Install Rust
RUN curl https://sh.rustup.rs -sSf | \
    sh -s -- --default-toolchain=${RUST_VERSION} --profile=minimal -y \
    && ${CARGO_HOME}/bin/rustup component add rustfmt

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
