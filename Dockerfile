# Debian Version
FROM debian:sid-20241202-slim@sha256:2eac978892d960f967fdad9a5387eb0bf5addfa3fab7f6fa09a00e0adff7975d

# Rust version
ARG RUST_VERSION=nightly-2024-12-03

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
