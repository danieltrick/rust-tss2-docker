# Debian Version
ARG DEBIAN_VERS=debian:12.7-slim

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Stage #1
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
FROM $DEBIAN_VERS AS build

# Rust version
ARG RUST_VERSION=1.81.0

# Set up environment
ENV RUSTUP_HOME=/opt/rust/rustup
ENV CARGO_HOME=/opt/rust/cargo

# Provide the 'install_packages' tool
COPY src/install_packages.sh /usr/sbin/install_packages

# Install build dependencies
RUN install_packages \
    ca-certificates \
    curl \
    rdfind

# Install Rust
RUN curl https://sh.rustup.rs -sSf | \
    sh -s -- --default-toolchain=${RUST_VERSION} --profile=minimal -y \
    && ${CARGO_HOME}/bin/rustup component add rustfmt \
    && rdfind -makeresultsfile false -makesymlinks true /opt/rust/

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Stage #2
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
FROM $DEBIAN_VERS

# Set up environment
ENV RUSTUP_HOME=/opt/rust/rustup
ENV CARGO_HOME=/opt/rust/cargo
ENV CARGO_TARGET_DIR=/var/tmp/rust/target

# Provide the 'install_packages' tool
COPY --from=build /usr/sbin/install_packages /usr/sbin/

# Copy Rust/Cargo files
COPY --from=build /opt/rust/ /opt/rust/

# Install runtime dependencies
RUN install_packages \
    ca-certificates \
    gcc \
    libclang-dev \
    libtss2-dev \
    pkg-config

# Copy Rust/Cargo files
COPY --from=build /opt/rust/ /opt/rust/

# Copy entry-point script
COPY bin/entry-point.sh /opt/rust/entry-point.sh

# Copy example project
COPY src/example/ /var/opt/rust/src/

# Working directory
WORKDIR /var/opt/rust/src

# Entry point
ENTRYPOINT ["/opt/rust/entry-point.sh"]
