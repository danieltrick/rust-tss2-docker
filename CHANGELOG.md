# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/).

## r4 - 2024-08-30

### Changed
- Switched base system from `debian:bookworm-slim` to `bitnami/minideb:bookworm`

## r3 - 2024-08-30

### Changed
- Implemented multi-stage build to further reduce image size.

## r2 - 2024-08-29

### Changed
- Install Rust and Cargo to the *default* locations.
- Install Rust toolchain with the `minimal` profile.

## r1 - 2024-08-27

- This is the first public release of this project.
