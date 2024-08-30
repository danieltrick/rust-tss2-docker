# Debian Version
ARG DEBIAN_VERS=bookworm-20240812-slim

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Stage #1
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
FROM debian:$DEBIAN_VERS AS build

# Rust version
ARG RUST_VERSION=1.80.0

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update \
    && apt-get install -y \
       curl \
       rdfind \
    && rm -vrf /var/lib/apt/lists/* /var/cache/apt/*

# Install Rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain=${RUST_VERSION} --profile=minimal -y \
    && rdfind -makeresultsfile false -makesymlinks true /root

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Stage #2
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
FROM debian:$DEBIAN_VERS

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
       ca-certificates \
       gcc \
       libclang-dev \
       libtss2-dev \
       pkg-config \
    && rm -vrf /var/lib/apt/lists/* /var/cache/apt/*

# Copy Rust/Cargo files
COPY --from=build /root/ /root/

# Start the shell
ENTRYPOINT ["/bin/bash", "-l"]
