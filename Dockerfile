# Debian Version
ARG DEBIAN_VERS=bitnami/minideb:bookworm

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Stage #1
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
FROM $DEBIAN_VERS AS build

# Rust version
ARG RUST_VERSION=1.80.0

ENV DEBIAN_FRONTEND=noninteractive

# Install build dependencies
RUN install_packages \
    ca-certificates \
    curl \
    rdfind

# Install Rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain=${RUST_VERSION} --profile=minimal -y \
    && rdfind -makeresultsfile false -makesymlinks true /root

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
COPY --from=build /root/ /root/

# Create symlinks
RUN ln -s -t /usr/local/bin /root/.cargo/bin/*

# Start the shell
ENTRYPOINT ["/bin/bash"]
