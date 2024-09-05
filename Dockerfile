# Debian Version
ARG DEBIAN_VERS=bitnami/minideb:bookworm

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Stage #1
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
FROM $DEBIAN_VERS AS build

# Rust version
ARG RUST_VERSION=1.81.0

ENV DEBIAN_FRONTEND=noninteractive

# Install build dependencies
RUN install_packages \
    ca-certificates \
    curl \
    rdfind

# Install Rust
RUN curl https://sh.rustup.rs -sSf | \
        CARGO_HOME=/opt/rust/cargo RUSTUP_HOME=/opt/rust/rustup \
        sh -s -- --default-toolchain=${RUST_VERSION} --profile=minimal -y \
    && rdfind -makeresultsfile false -makesymlinks true /opt/rust/

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Stage #2
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
FROM $DEBIAN_VERS

ENV DEBIAN_FRONTEND=noninteractive

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

# Set up environment
ENV RUSTUP_HOME=/opt/rust/rustup
ENV CARGO_HOME=/opt/rust/cargo
ENV CARGO_TARGET_DIR=/var/tmp/rust/target

# Working directory
WORKDIR /var/opt/rust/src

# Entry point
ENTRYPOINT ["/opt/rust/entry-point.sh"]
