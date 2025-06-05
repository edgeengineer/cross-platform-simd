import Testing
#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

// MARK: - Simple Property-Based Testing Framework

/// A simple property-based testing framework for Swift Testing
struct PropertyTesting {
    
    /// Default number of test cases to generate
    static let defaultTestCases = 100
    
    /// Generates random values for property testing
    enum Generator {
        
        /// Generates a random Float in the given range
        static func float(min: Float = -1000, max: Float = 1000) -> Float {
            return Float.random(in: min...max)
        }
        
        /// Generates a random Double in the given range
        static func double(min: Double = -1000, max: Double = 1000) -> Double {
            return Double.random(in: min...max)
        }
        
        /// Generates a random Int32 in the given range
        static func int32(min: Int32 = -1000, max: Int32 = 1000) -> Int32 {
            return Int32.random(in: min...max)
        }
        
        /// Generates a random Int64 in the given range
        static func int64(min: Int64 = -1000, max: Int64 = 1000) -> Int64 {
            return Int64.random(in: min...max)
        }
        
        /// Generates a random array of Floats
        static func floatArray(size: Int = 10, min: Float = -100, max: Float = 100) -> [Float] {
            return (0..<size).map { _ in float(min: min, max: max) }
        }
        
        /// Generates a random array of Doubles
        static func doubleArray(size: Int = 10, min: Double = -100, max: Double = 100) -> [Double] {
            return (0..<size).map { _ in double(min: min, max: max) }
        }
        
        /// Generates a random array of Int32s
        static func int32Array(size: Int = 10, min: Int32 = -100, max: Int32 = 100) -> [Int32] {
            return (0..<size).map { _ in int32(min: min, max: max) }
        }
        
        /// Generates a random array of Int64s
        static func int64Array(size: Int = 10, min: Int64 = -100, max: Int64 = 100) -> [Int64] {
            return (0..<size).map { _ in int64(min: min, max: max) }
        }
        
        /// Generates arrays with specific sizes for SIMD alignment testing
        static func floatArrayWithSize(_ size: Int) -> [Float] {
            return floatArray(size: size)
        }
        
        /// Generates non-empty arrays
        static func nonEmptyFloatArray(maxSize: Int = 20) -> [Float] {
            let size = Int.random(in: 1...maxSize)
            return floatArray(size: size)
        }
        
        /// Generates arrays with different sizes for mismatch testing
        static func mismatchedFloatArrays() -> ([Float], [Float]) {
            let size1 = Int.random(in: 1...10)
            let size2 = Int.random(in: 1...10)
            // Ensure they're different
            let finalSize2 = size2 == size1 ? size2 + 1 : size2
            return (floatArray(size: size1), floatArray(size: finalSize2))
        }
    }
    
    /// Runs a property test with the specified number of test cases
    static func forAll<T>(
        _ testCases: Int = defaultTestCases,
        generate: () -> T,
        property: (T) throws -> Bool
    ) throws {
        for i in 0..<testCases {
            let value = generate()
            let result = try property(value)
            if !result {
                throw PropertyTestFailure.propertyViolation(
                    "Property failed on test case \(i + 1)/\(testCases) with value: \(value)"
                )
            }
        }
    }
    
    /// Runs a property test with two generators
    static func forAll<T, U>(
        _ testCases: Int = defaultTestCases,
        generate1: () -> T,
        generate2: () -> U,
        property: (T, U) throws -> Bool
    ) throws {
        for i in 0..<testCases {
            let value1 = generate1()
            let value2 = generate2()
            let result = try property(value1, value2)
            if !result {
                throw PropertyTestFailure.propertyViolation(
                    "Property failed on test case \(i + 1)/\(testCases) with values: \(value1), \(value2)"
                )
            }
        }
    }
    
    /// Runs a property test with three generators
    static func forAll<T, U, V>(
        _ testCases: Int = defaultTestCases,
        generate1: () -> T,
        generate2: () -> U,
        generate3: () -> V,
        property: (T, U, V) throws -> Bool
    ) throws {
        for i in 0..<testCases {
            let value1 = generate1()
            let value2 = generate2()
            let value3 = generate3()
            let result = try property(value1, value2, value3)
            if !result {
                throw PropertyTestFailure.propertyViolation(
                    "Property failed on test case \(i + 1)/\(testCases) with values: \(value1), \(value2), \(value3)"
                )
            }
        }
    }
}

/// Errors that can occur during property testing
enum PropertyTestFailure: Error, LocalizedError {
    case propertyViolation(String)
    
    var errorDescription: String? {
        switch self {
        case .propertyViolation(let message):
            return "Property test failed: \(message)"
        }
    }
}

// MARK: - Helper Functions for Approximate Equality

/// Checks if two Float values are approximately equal
func isApproximatelyEqual(_ a: Float, _ b: Float, tolerance: Float = 1e-5) -> Bool {
    return abs(a - b) <= tolerance
}

/// Checks if two Double values are approximately equal
func isApproximatelyEqual(_ a: Double, _ b: Double, tolerance: Double = 1e-10) -> Bool {
    return abs(a - b) <= tolerance
}

/// Checks if two Float arrays are approximately equal
func areApproximatelyEqual(_ a: [Float], _ b: [Float], tolerance: Float = 1e-5) -> Bool {
    guard a.count == b.count else { return false }
    return zip(a, b).allSatisfy { isApproximatelyEqual($0, $1, tolerance: tolerance) }
}

/// Checks if two Double arrays are approximately equal
func areApproximatelyEqual(_ a: [Double], _ b: [Double], tolerance: Double = 1e-10) -> Bool {
    guard a.count == b.count else { return false }
    return zip(a, b).allSatisfy { isApproximatelyEqual($0, $1, tolerance: tolerance) }
}

/// Utility to safely unwrap Result types for property testing
func unwrapResults<T, E: Error>(_ result1: Result<T, E>, _ result2: Result<T, E>) -> (T, T)? {
    switch (result1, result2) {
    case (.success(let val1), .success(let val2)):
        return (val1, val2)
    default:
        return nil
    }
}

/// Utility to safely unwrap a single Result for property testing
func unwrapResult<T, E: Error>(_ result: Result<T, E>) -> T? {
    switch result {
    case .success(let value):
        return value
    case .failure:
        return nil
    }
}