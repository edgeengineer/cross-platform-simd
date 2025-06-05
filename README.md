# CrossPlatformSIMD

A Swift library that provides cross-platform SIMD (Single Instruction, Multiple Data) operations for high-performance vector computations.

## Features

- Cross-platform support (macOS, iOS, tvOS, watchOS, visionOS)
- Optimized vector operations using Swift's built-in SIMD types
- Support for Float and Double precision
- Matrix multiplication
- Swift 6.1 compatible

## Installation

Add this package to your Swift project using Swift Package Manager:

```swift
dependencies: [
    .package(url: "path/to/CrossPlatformSIMD", from: "1.0.0")
]
```

## Usage

```swift
import CrossPlatformSIMD

let simd = SIMDOperations()

// Vector addition
let a: [Float] = [1.0, 2.0, 3.0, 4.0]
let b: [Float] = [5.0, 6.0, 7.0, 8.0]
let sum = simd.addVectors(a, b) // [6.0, 8.0, 10.0, 12.0]

// Dot product
let dot = simd.dotProduct(a, b) // 70.0

// Vector multiplication
let product = simd.multiplyVectors(a, b) // [5.0, 12.0, 21.0, 32.0]

// Scale vector
let scaled = simd.scaleVector(a, by: 2.0) // [2.0, 4.0, 6.0, 8.0]

// Sum all elements
let total = simd.sumVector(a) // 10.0

// Matrix multiplication
let matrixA = [[1.0, 2.0], [3.0, 4.0]]
let matrixB = [[5.0, 6.0], [7.0, 8.0]]
let matrixResult = simd.matrixMultiply(matrixA, matrixB)
// [[19.0, 22.0], [43.0, 50.0]]
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