#!/bin/sh

# --- Variables ---
BUILD_DIR="project"
CACHE_DIR="cache"
ENV_DIR="env"

# --- Test setup ---
# Clean folders
rm -rf $BUILD_DIR || true
rm -rf $CACHE_DIR || true
rm -rf $ENV_DIR || true

# Create cargo project
mkdir $BUILD_DIR
cd $BUILD_DIR
cargo init

# --- Run Scripts ---
export CARGO_WORKSPACE=.
export RUST_CHANNEL=stable
export RUST_TARGET=x86_64-unknown-linux-gnu

bin/detect $BUILD_DIR && bin/compile $BUILD_DIR $CACHE_DIR $ENV_DIR
