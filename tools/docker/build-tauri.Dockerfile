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
    useradd --uid 1000 --create-home --shell=/bin/bash builder; \
    mkdir /src; \
    chown builder:builder /src;

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
    build-essential libayatana-appindicator3-dev libgtk-3-dev librsvg2-dev libssl-dev libwebkit2gtk-4.0-dev tree xdg-utils;

USER builder
WORKDIR /tmp

ARG NVM_VERSION=v0.39.1
ARG NVM_INSTALL_SHA=fabc489b39a5e9c999c7cab4d281cdbbcbad10ec2f8b9a7f7144ad701b6bfdc7
ARG NODE_VERSION=v18.4.0
ARG NPM_VERSION=^8.13.2
ARG YARN_VERSION=^1.22.19

SHELL ["/bin/bash", "--login", "-c"]
RUN set -eux; \
    wget -O nvm_install.sh https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh; \
    echo "${NVM_INSTALL_SHA} nvm_install.sh" | sha256sum -c -; \
    bash nvm_install.sh; \
    rm nvm_install.sh; \
    export NVM_DIR=/home/builder/.nvm; \
    source /home/builder/.bashrc; \
    source /home/builder/.nvm/nvm.sh; \
    set +x; \
    nvm --version; \
    nvm install ${NODE_VERSION}; \
    nvm alias default ${NODE_VERSION}; \
    nvm use default;

ENV NVM_BIN=/home/builder/.nvm/versions/node/${NODE_VERSION}/bin
ENV PATH=$NVM_BIN:$PATH

RUN set -eu; \
    npm install --location=global npm@${NPM_VERSION} yarn@${YARN_VERSION}; \
    set -x; \
    node --version; \
    npm --version; \
    yarn --version;

WORKDIR /src
