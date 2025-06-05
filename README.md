# CrossPlatformSIMD

[![Swift](https://github.com/edgeengineer/cross-platform-simd/actions/workflows/swift.yml/badge.svg)](https://github.com/edgeengineer/cross-platform-simd/actions/workflows/swift.yml)
[![Swift Version](https://img.shields.io/badge/Swift-6.1-orange.svg)](https://swift.org)
[![Platforms](https://img.shields.io/badge/Platforms-macOS%20%7C%20Linux%20%7C%20iOS%20%7C%20tvOS%20%7C%20watchOS%20%7C%20visionOS-blue.svg)](https://swift.org)

A Swift library that provides cross-platform SIMD (Single Instruction, Multiple Data) operations for high-performance vector computations.

## Features

- Cross-platform support (macOS, iOS, tvOS, watchOS, visionOS, Linux via GitHub Actions)
- Optimized vector operations using Swift's built-in SIMD types
- Support for Float and Double precision
- Matrix multiplication for both Float and Double
- Direct SIMD type APIs for zero-overhead operations
- Swift 6.1 compatible with FoundationEssentials support
- Safe error handling with Result types
- Flexible SIMD width support (SIMD4, SIMD8, SIMD16)
- Comprehensive test coverage including edge cases

## Installation

Add this package to your Swift project using Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/edgeengineer/cross-platform-simd.git", from: "0.0.1")
]
```

## Usage

```swift
import CrossPlatformSIMD

let simd = SIMDOperations()

// Vector addition
let a: [Float] = [1.0, 2.0, 3.0, 4.0]
let b: [Float] = [5.0, 6.0, 7.0, 8.0]

switch simd.addVectors(a, b) {
case .success(let sum):
    print(sum) // [6.0, 8.0, 10.0, 12.0]
case .failure(let error):
    print("Error: \(error.localizedDescription)")
}

// Dot product
switch simd.dotProduct(a, b) {
case .success(let dot):
    print(dot) // 70.0
case .failure(let error):
    print("Error: \(error.localizedDescription)")
}

// Vector multiplication
switch simd.multiplyVectors(a, b) {
case .success(let product):
    print(product) // [5.0, 12.0, 21.0, 32.0]
case .failure(let error):
    print("Error: \(error.localizedDescription)")
}

// Scale vector
switch simd.scaleVector(a, by: 2.0) {
case .success(let scaled):
    print(scaled) // [2.0, 4.0, 6.0, 8.0]
case .failure(let error):
    print("Error: \(error.localizedDescription)")
}

// Sum all elements
switch simd.sumVector(a) {
case .success(let total):
    print(total) // 10.0
case .failure(let error):
    print("Error: \(error.localizedDescription)")
}

// Matrix multiplication (supports both Float and Double)
let matrixA = [[1.0, 2.0], [3.0, 4.0]]
let matrixB = [[5.0, 6.0], [7.0, 8.0]]

switch simd.matrixMultiply(matrixA, matrixB) {
case .success(let result):
    print(result) // [[19.0, 22.0], [43.0, 50.0]]
case .failure(let error):
    print("Error: \(error.localizedDescription)")
}
```

### Error Handling

The library uses `Result` types for error handling instead of fatal errors. Common errors include:

- `mismatchedVectorLengths`: When vectors have different lengths
- `emptyInput`: When empty arrays are provided
- `invalidMatrixDimensions`: When matrix dimensions are incompatible for multiplication

```swift
// Example: Handling mismatched vector lengths
let vectorA = [1.0, 2.0, 3.0]
let vectorB = [4.0, 5.0]

switch simd.addVectors(vectorA, vectorB) {
case .success(let result):
    print(result)
case .failure(let error):
    print(error.localizedDescription) // "Vector lengths do not match: 3 != 2"
}
```

### Direct SIMD Type APIs

For maximum performance when working with SIMD types directly:

```swift
import simd
import CrossPlatformSIMD

let simd = SIMDOperations()

// Direct SIMD4 operations (zero overhead)
let a = SIMD4<Float>(1.0, 2.0, 3.0, 4.0)
let b = SIMD4<Float>(5.0, 6.0, 7.0, 8.0)

let sum = simd.addVectors(a, b)        // SIMD4<Float>(6.0, 8.0, 10.0, 12.0)
let dot = simd.dotProduct(a, b)        // 70.0
let product = simd.multiplyVectors(a, b) // SIMD4<Float>(5.0, 12.0, 21.0, 32.0)
let scaled = simd.scaleVector(a, by: 2.0) // SIMD4<Float>(2.0, 4.0, 6.0, 8.0)
let total = simd.sumVector(a)          // 10.0

// Conversion helpers for array to SIMD chunking
let array: [Float] = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0]
let (chunks, remainder) = simd.toSIMD4Chunks(array)
// chunks: [SIMD4(1,2,3,4), SIMD4(5,6,7,8)]
// remainder: [9.0]

let reconstructed = simd.fromSIMD4Chunks(chunks, remainder: remainder)
// [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0]
```

## Performance

This library automatically uses SIMD instructions available on the target platform to accelerate vector operations. Operations are performed in chunks of 4 elements at a time for optimal performance.

## Testing

Run tests using Swift's built-in testing framework:

```bash
swift test
```

## Requirements

- Swift 6.1+
- Xcode 16.0+ (for development)
- macOS 12.0+ / iOS 15.0+ / tvOS 15.0+ / watchOS 8.0+ / visionOS 1.0+