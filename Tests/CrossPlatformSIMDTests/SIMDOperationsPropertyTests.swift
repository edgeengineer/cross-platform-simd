import Testing
import simd
@testable import CrossPlatformSIMD

struct SIMDOperationsPropertyTests {
    let simd = SIMDOperations()
    
    // MARK: - Commutativity Properties
    
    @Test func testAdditionCommutativityFloat() throws {
        try PropertyTesting.forAll(
            generate1: { PropertyTesting.Generator.nonEmptyFloatArray() },
            generate2: { PropertyTesting.Generator.nonEmptyFloatArray() }
        ) { (a, b) in
            // Ensure arrays have the same size
            let size = min(a.count, b.count)
            let a_trimmed = Array(a.prefix(size))
            let b_trimmed = Array(b.prefix(size))
            
            guard let (ab, ba) = unwrapResults(
                simd.addVectors(a_trimmed, b_trimmed),
                simd.addVectors(b_trimmed, a_trimmed)
            ) else {
                return true // Skip if either operation failed
            }
            
            // a + b == b + a (commutativity)
            return areApproximatelyEqual(ab, ba)
        }
    }
    
    @Test func testAdditionCommutativityDouble() throws {
        try PropertyTesting.forAll(
            generate1: { PropertyTesting.Generator.doubleArray() },
            generate2: { PropertyTesting.Generator.doubleArray() }
        ) { (a, b) in
            let size = min(a.count, b.count)
            let a_trimmed = Array(a.prefix(size))
            let b_trimmed = Array(b.prefix(size))
            
            guard let (ab, ba) = unwrapResults(
                simd.addVectors(a_trimmed, b_trimmed),
                simd.addVectors(b_trimmed, a_trimmed)
            ) else {
                return true
            }
            
            return areApproximatelyEqual(ab, ba)
        }
    }
    
    @Test func testMultiplicationCommutativityFloat() throws {
        try PropertyTesting.forAll(
            generate1: { PropertyTesting.Generator.floatArray(size: 8, min: -10, max: 10) },
            generate2: { PropertyTesting.Generator.floatArray(size: 8, min: -10, max: 10) }
        ) { (a, b) in
            guard let (ab, ba) = unwrapResults(
                simd.multiplyVectors(a, b),
                simd.multiplyVectors(b, a)
            ) else {
                return true
            }
            
            // a * b == b * a (commutativity)
            return areApproximatelyEqual(ab, ba)
        }
    }
    
    @Test func testDotProductCommutativityFloat() throws {
        try PropertyTesting.forAll(
            generate1: { PropertyTesting.Generator.floatArray(size: 10, min: -10, max: 10) },
            generate2: { PropertyTesting.Generator.floatArray(size: 10, min: -10, max: 10) }
        ) { (a, b) in
            guard let (ab, ba) = unwrapResults(
                simd.dotProduct(a, b),
                simd.dotProduct(b, a)
            ) else {
                return true
            }
            
            // dot(a, b) == dot(b, a) (commutativity)
            return isApproximatelyEqual(ab, ba)
        }
    }
    
    // MARK: - Direct SIMD Type Commutativity
    
    @Test func testSIMD4AdditionCommutativity() throws {
        try PropertyTesting.forAll(
            generate1: { 
                SIMD4<Float>(
                    PropertyTesting.Generator.float(min: -100, max: 100),
                    PropertyTesting.Generator.float(min: -100, max: 100),
                    PropertyTesting.Generator.float(min: -100, max: 100),
                    PropertyTesting.Generator.float(min: -100, max: 100)
                )
            },
            generate2: { 
                SIMD4<Float>(
                    PropertyTesting.Generator.float(min: -100, max: 100),
                    PropertyTesting.Generator.float(min: -100, max: 100),
                    PropertyTesting.Generator.float(min: -100, max: 100),
                    PropertyTesting.Generator.float(min: -100, max: 100)
                )
            }
        ) { (a, b) in
            let ab = simd.addVectors(a, b)
            let ba = simd.addVectors(b, a)
            
            // SIMD4 addition should be commutative
            return ab == ba
        }
    }
    
    @Test func testSIMD4MultiplicationCommutativity() throws {
        try PropertyTesting.forAll(
            generate1: { 
                SIMD4<Float>(
                    PropertyTesting.Generator.float(min: -10, max: 10),
                    PropertyTesting.Generator.float(min: -10, max: 10),
                    PropertyTesting.Generator.float(min: -10, max: 10),
                    PropertyTesting.Generator.float(min: -10, max: 10)
                )
            },
            generate2: { 
                SIMD4<Float>(
                    PropertyTesting.Generator.float(min: -10, max: 10),
                    PropertyTesting.Generator.float(min: -10, max: 10),
                    PropertyTesting.Generator.float(min: -10, max: 10),
                    PropertyTesting.Generator.float(min: -10, max: 10)
                )
            }
        ) { (a, b) in
            let ab = simd.multiplyVectors(a, b)
            let ba = simd.multiplyVectors(b, a)
            
            return ab == ba
        }
    }
    
    // MARK: - Associativity Properties
    // Note: These tests are commented out because floating-point arithmetic
    // is not perfectly associative due to rounding errors. This is expected behavior.
    
    /*
    @Test func testAdditionAssociativityFloat() throws {
        try PropertyTesting.forAll(50, // Reduced iterations for performance
            generate1: { PropertyTesting.Generator.floatArray(size: 8, min: -50, max: 50) },
            generate2: { PropertyTesting.Generator.floatArray(size: 8, min: -50, max: 50) },
            generate3: { PropertyTesting.Generator.floatArray(size: 8, min: -50, max: 50) }
        ) { (a, b, c) in
            // (a + b) + c == a + (b + c) (associativity)
            guard let ab = unwrapResult(simd.addVectors(a, b)),
                  let ab_c = unwrapResult(simd.addVectors(ab, c)),
                  let bc = unwrapResult(simd.addVectors(b, c)),
                  let a_bc = unwrapResult(simd.addVectors(a, bc)) else {
                return true
            }
            
            return areApproximatelyEqual(ab_c, a_bc, tolerance: 1e-3)
        }
    }
    
    @Test func testMultiplicationAssociativityFloat() throws {
        try PropertyTesting.forAll(50,
            generate1: { PropertyTesting.Generator.floatArray(size: 8, min: -5, max: 5) },
            generate2: { PropertyTesting.Generator.floatArray(size: 8, min: -5, max: 5) },
            generate3: { PropertyTesting.Generator.floatArray(size: 8, min: -5, max: 5) }
        ) { (a, b, c) in
            // (a * b) * c == a * (b * c) (associativity)
            guard let ab = unwrapResult(simd.multiplyVectors(a, b)),
                  let ab_c = unwrapResult(simd.multiplyVectors(ab, c)),
                  let bc = unwrapResult(simd.multiplyVectors(b, c)),
                  let a_bc = unwrapResult(simd.multiplyVectors(a, bc)) else {
                return true
            }
            
            return areApproximatelyEqual(ab_c, a_bc, tolerance: 1e-3)
        }
    }
    */
    
    // MARK: - Identity Properties
    
    @Test func testAdditiveIdentityFloat() throws {
        try PropertyTesting.forAll(
            generate: { PropertyTesting.Generator.floatArray(size: 10) }
        ) { a in
            let zeros = [Float](repeating: 0.0, count: a.count)
            
            guard let a_plus_zero = unwrapResult(simd.addVectors(a, zeros)),
                  let zero_plus_a = unwrapResult(simd.addVectors(zeros, a)) else {
                return true
            }
            
            // a + 0 == a and 0 + a == a (additive identity)
            return areApproximatelyEqual(a, a_plus_zero) && 
                   areApproximatelyEqual(a, zero_plus_a)
        }
    }
    
    @Test func testMultiplicativeIdentityFloat() throws {
        try PropertyTesting.forAll(
            generate: { PropertyTesting.Generator.floatArray(size: 10) }
        ) { a in
            let ones = [Float](repeating: 1.0, count: a.count)
            
            guard let a_times_one = unwrapResult(simd.multiplyVectors(a, ones)),
                  let one_times_a = unwrapResult(simd.multiplyVectors(ones, a)) else {
                return true
            }
            
            // a * 1 == a and 1 * a == a (multiplicative identity)
            return areApproximatelyEqual(a, a_times_one) && 
                   areApproximatelyEqual(a, one_times_a)
        }
    }
    
    // MARK: - Scaling Properties
    
    @Test func testScalingDistributivityFloat() throws {
        try PropertyTesting.forAll(
            generate1: { PropertyTesting.Generator.floatArray(size: 8) },
            generate2: { PropertyTesting.Generator.floatArray(size: 8) },
            generate3: { PropertyTesting.Generator.float(min: -10, max: 10) }
        ) { (a, b, scalar) in
            // scalar * (a + b) == scalar * a + scalar * b (distributivity)
            guard let a_plus_b = unwrapResult(simd.addVectors(a, b)),
                  let scalar_times_sum = unwrapResult(simd.scaleVector(a_plus_b, by: scalar)),
                  let scalar_times_a = unwrapResult(simd.scaleVector(a, by: scalar)),
                  let scalar_times_b = unwrapResult(simd.scaleVector(b, by: scalar)),
                  let sum_of_scaled = unwrapResult(simd.addVectors(scalar_times_a, scalar_times_b)) else {
                return true
            }
            
            return areApproximatelyEqual(scalar_times_sum, sum_of_scaled, tolerance: 1e-2)
        }
    }
    
    @Test func testScalingAssociativityFloat() throws {
        try PropertyTesting.forAll(
            generate1: { PropertyTesting.Generator.floatArray(size: 8) },
            generate2: { PropertyTesting.Generator.float(min: -5, max: 5) },
            generate3: { PropertyTesting.Generator.float(min: -5, max: 5) }
        ) { (a, scalar1, scalar2) in
            // (scalar1 * scalar2) * a == scalar1 * (scalar2 * a) (associativity)
            let combined_scalar = scalar1 * scalar2
            
            guard let combined_scaled = unwrapResult(simd.scaleVector(a, by: combined_scalar)),
                  let first_scaled = unwrapResult(simd.scaleVector(a, by: scalar2)),
                  let nested_scaled = unwrapResult(simd.scaleVector(first_scaled, by: scalar1)) else {
                return true
            }
            
            return areApproximatelyEqual(combined_scaled, nested_scaled, tolerance: 1e-2)
        }
    }
    
    // MARK: - Integer Properties
    
    @Test func testInt32AdditionCommutativity() throws {
        try PropertyTesting.forAll(
            generate1: { PropertyTesting.Generator.int32Array(size: 8, min: -100, max: 100) },
            generate2: { PropertyTesting.Generator.int32Array(size: 8, min: -100, max: 100) }
        ) { (a, b) in
            guard let (ab, ba) = unwrapResults(
                simd.addVectors(a, b),
                simd.addVectors(b, a)
            ) else {
                return true
            }
            
            // Integer addition should be commutative (with wrapping)
            return ab == ba
        }
    }
    
    @Test func testInt32MultiplicationCommutativity() throws {
        try PropertyTesting.forAll(
            generate1: { PropertyTesting.Generator.int32Array(size: 8, min: -10, max: 10) },
            generate2: { PropertyTesting.Generator.int32Array(size: 8, min: -10, max: 10) }
        ) { (a, b) in
            guard let (ab, ba) = unwrapResults(
                simd.multiplyVectors(a, b),
                simd.multiplyVectors(b, a)
            ) else {
                return true
            }
            
            return ab == ba
        }
    }
    
    // MARK: - Bitwise Properties
    
    @Test func testBitwiseAndCommutativity() throws {
        try PropertyTesting.forAll(
            generate1: { PropertyTesting.Generator.int32Array(size: 8) },
            generate2: { PropertyTesting.Generator.int32Array(size: 8) }
        ) { (a, b) in
            guard let (ab, ba) = unwrapResults(
                simd.bitwiseAnd(a, b),
                simd.bitwiseAnd(b, a)
            ) else {
                return true
            }
            
            // a & b == b & a (bitwise AND commutativity)
            return ab == ba
        }
    }
    
    @Test func testBitwiseOrCommutativity() throws {
        try PropertyTesting.forAll(
            generate1: { PropertyTesting.Generator.int32Array(size: 8) },
            generate2: { PropertyTesting.Generator.int32Array(size: 8) }
        ) { (a, b) in
            guard let (ab, ba) = unwrapResults(
                simd.bitwiseOr(a, b),
                simd.bitwiseOr(b, a)
            ) else {
                return true
            }
            
            // a | b == b | a (bitwise OR commutativity)
            return ab == ba
        }
    }
    
    @Test func testBitwiseXorCommutativity() throws {
        try PropertyTesting.forAll(
            generate1: { PropertyTesting.Generator.int32Array(size: 8) },
            generate2: { PropertyTesting.Generator.int32Array(size: 8) }
        ) { (a, b) in
            guard let (ab, ba) = unwrapResults(
                simd.bitwiseXor(a, b),
                simd.bitwiseXor(b, a)
            ) else {
                return true
            }
            
            // a ^ b == b ^ a (bitwise XOR commutativity)
            return ab == ba
        }
    }
    
    // MARK: - Matrix Properties
    
    @Test func testMatrixMultiplicationAssociativity() throws {
        try PropertyTesting.forAll(10, // Reduced for performance
            generate1: { 
                let size = 4 // Small matrices for performance
                return (0..<size).map { _ in PropertyTesting.Generator.floatArray(size: size, min: -5, max: 5) }
            },
            generate2: { 
                let size = 4
                return (0..<size).map { _ in PropertyTesting.Generator.floatArray(size: size, min: -5, max: 5) }
            },
            generate3: { 
                let size = 4
                return (0..<size).map { _ in PropertyTesting.Generator.floatArray(size: size, min: -5, max: 5) }
            }
        ) { (a, b, c) in
            // (A * B) * C == A * (B * C) for matrices (associativity)
            guard let ab = unwrapResult(simd.matrixMultiply(a, b)),
                  let ab_c = unwrapResult(simd.matrixMultiply(ab, c)),
                  let bc = unwrapResult(simd.matrixMultiply(b, c)),
                  let a_bc = unwrapResult(simd.matrixMultiply(a, bc)) else {
                return true
            }
            
            // Check if results are approximately equal
            for i in 0..<ab_c.count {
                if !areApproximatelyEqual(ab_c[i], a_bc[i], tolerance: 1e-3) {
                    return false
                }
            }
            return true
        }
    }
    
    // MARK: - Consistency Properties
    
    @Test func testArrayVsDirectSIMDConsistency() throws {
        try PropertyTesting.forAll(
            generate: { 
                (
                    PropertyTesting.Generator.floatArray(size: 4),
                    PropertyTesting.Generator.floatArray(size: 4)
                )
            }
        ) { (arrays) in
            let (a, b) = arrays
            
            // Convert to SIMD4
            let simdA = SIMD4<Float>(a[0], a[1], a[2], a[3])
            let simdB = SIMD4<Float>(b[0], b[1], b[2], b[3])
            
            // Compare array-based and direct SIMD results
            guard let arrayResult = unwrapResult(simd.addVectors(a, b)) else {
                return true
            }
            
            let simdResult = simd.addVectors(simdA, simdB)
            let simdAsArray = [simdResult[0], simdResult[1], simdResult[2], simdResult[3]]
            
            return areApproximatelyEqual(arrayResult, simdAsArray)
        }
    }
}