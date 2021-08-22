#!/usr/bin/env bash

set -o errexit

# Freeze versions
PROTOBUF_VERSION=3.13.0
GRPC_GATEWAY_VERSION=1.14.8
PROTOC_GEN_GO_VERSION=1.4.2

install_protobuf_compiler() {
    WORKDIR=$(mktemp -d)
    echo "downloading protobuf v${PROTOBUF_VERSION}"
    curl --silent --location https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOBUF_VERSION}/protoc-${PROTOBUF_VERSION}-linux-x86_64.zip --output "$WORKDIR/protoc.zip"
    mkdir -p "$WORKDIR/protoc"
    unzip "$WORKDIR/protoc.zip" -d "$WORKDIR/protoc" >/dev/null
    fix_read_permissions "$WORKDIR/protoc"
    cp --recursive "$WORKDIR/protoc/bin/protoc" /usr/bin/
    cp --recursive "$WORKDIR/protoc/include/google" /usr/include/
    rm -rf "$WORKDIR"
    chmod +x /usr/bin/protoc
}

install_go_proto_tools() {
    # We use protoc-get-go to generate GRPC API
    echo "installing protobuf plugin for Go v${PROTOC_GEN_GO_VERSION}"
    go get github.com/golang/protobuf/protoc-gen-go@v${PROTOC_GEN_GO_VERSION}

    # We use grpc-gateway to generate fallback REST API over GRPC API
    echo "installing grpc-gateway v${GRPC_GATEWAY_VERSION}"
    go get github.com/grpc-ecosystem/grpc-gateway/protoc-gen-grpc-gateway@v${GRPC_GATEWAY_VERSION}
    go get github.com/grpc-ecosystem/grpc-gateway/protoc-gen-swagger@v${GRPC_GATEWAY_VERSION}

    # Move grpc-gateway source code to predictable path in /go/src.
    local SRC=/go/pkg/mod/github.com/grpc-ecosystem/grpc-gateway\@v${GRPC_GATEWAY_VERSION}
    local DEST=/go/src/github.com/grpc-ecosystem/grpc-gateway
    mkdir -m 777 -p "$DEST"
    cp --recursive "$SRC/." "$DEST"
}

install_protobuf_compiler
install_go_proto_tools

fix_read_permissions "/go"
fix_write_permissions "/go/pkg"
fix_write_permissions "/go/src"

# Remove this script
rm $(readlink -f $0)
