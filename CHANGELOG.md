# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/).

## r17 - 2025-07-01

### Changed
- Updated Rust/Cargo toolchain to version 1.88.0 (2025-06-26).

## r16 - 2025-06-12

### Changed
- Updated Rust/Cargo toolchain to version 1.87.0 (2025-05-15).
- Updated base system to Debian 12.11 (2025-05-17).

## r14 - 2025-04-04

### Changed
- Updated Rust/Cargo toolchain to version 1.86.0 (2025-04-03).

## r13 - 2025-03-20

### Changed
- Updated Rust/Cargo toolchain to version 1.85.1 (2025-03-18).
- Updated base system to Debian 12.10 (2025-03-15).

## r12 - 2025-02-25

### Added
- Enabled multi-platform build for `linux/amd64` and `linux/arm64`

### Changed
- Updated Rust/Cargo toolchain to version 1.85.0 (2025-02-20).

## r11 - 2025-01-11

### Changed
- Updated Rust/Cargo toolchain to version 1.84.0 (2025-01-09).

## r10 - 2024-12-03

### Changed
- Updated Rust/Cargo toolchain to version 1.83.0 (2024-11-28).
- Updated base system to Debian 12.8 (2024-12-03).

## r9 - 2024-10-18

### Changed
- Updated Rust/Cargo toolchain to version 1.82.0 (2024-10-17).

## r8 - 2024-09-28

### Changed
- Updated base system to Debian 12.7 (2024-09-27).

## r7 - 2024-09-20

### Changed
- Switched base system from `debian:12.7-slim` to `rust:1.*-slim-bookworm`.

### Added
- Included the `cargo-rebuild` command.

## r6 - 2024-09-10

### Added
- Included the `rustfmt` component with the Rust installation.

### Changed
- Switched base system from `bitnami/minideb:bookworm` to `debian:12.7-slim`.

## r5 - 2024-09-05

### Changed
- Updated Rust/Cargo toolchain to version 1.81.0 (2024-09-05).

## r4 - 2024-08-31

### Changed
- Switched base system from `debian:bookworm-slim` to `bitnami/minideb:bookworm`.

### Added
- Added example Rust/Cargo project to the container image.

## r3 - 2024-08-30

### Changed
- Implemented multi-stage build to further reduce image size.

## r2 - 2024-08-29

### Changed
- Install Rust and Cargo to the *default* locations.
- Install Rust toolchain with the `minimal` profile.

## r1 - 2024-08-27

- This is the first public release of this project.
