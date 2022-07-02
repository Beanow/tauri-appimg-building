FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
    ca-certificates gcc libc6-dev wget curl;

ARG RUSTUP_VERSION=1.24.3
ARG RUSTUP_SHA=3dc5ef50861ee18657f9db2eeb7392f9c2a6c95c90ab41e45ab4ca71476b4338
ARG RUST_ARCH=x86_64-unknown-linux-gnu
ARG RUST_VERSION=1.62.0

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH

RUN set -eux; \
    wget "https://static.rust-lang.org/rustup/archive/${RUSTUP_VERSION}/${RUST_ARCH}/rustup-init"; \
    echo "${RUSTUP_SHA} *rustup-init" | sha256sum -c -; \
    chmod +x rustup-init; \
    ./rustup-init -y --no-modify-path --profile minimal --default-toolchain $RUST_VERSION --default-host ${RUST_ARCH}; \
    rm rustup-init; \
    chmod -R a+w $RUSTUP_HOME $CARGO_HOME; \
    rustup --version; \
    cargo --version; \
    rustc --version;

RUN set -eux; \
    useradd --uid 1000 --create-home builder; \
    mkdir /src; \
    chown builder:builder /src;

# Helps save time by populating crates.io index to the current situation.
RUN cargo search > /dev/null;
RUN chown -R builder:builder /usr/local/cargo/*;

USER builder
WORKDIR /src
