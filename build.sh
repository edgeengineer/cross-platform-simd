#!/bin/bash

# Build script for CrossPlatformSIMD

set -e

COMMAND=${1:-build}

case $COMMAND in
    build)
        echo "Building CrossPlatformSIMD..."
        swift build -c release
        ;;
    test)
        echo "Running tests..."
        swift test
        ;;
    clean)
        echo "Cleaning build artifacts..."
        swift package clean
        rm -rf .build
        ;;
    benchmark)
        echo "Building and running benchmarks..."
        swift build -c release
        echo "Benchmarks not implemented yet"
        ;;
    *)
        echo "Usage: $0 [build|test|clean|benchmark]"
        echo "  build     - Build the library in release mode"
        echo "  test      - Run all tests"
        echo "  clean     - Clean build artifacts"
        echo "  benchmark - Build and run benchmarks (not implemented)"
        exit 1
        ;;
esac