#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif
import simd

extension SIMDOperations {
    
    // MARK: - Integer SIMD Operations
    
    /// Adds two Int32 vectors element-wise using SIMD operations
    /// - Parameters:
    ///   - a: First vector
    ///   - b: Second vector
    /// - Returns: Result containing the sum vector or an error
    public func addVectors(_ a: [Int32], _ b: [Int32]) -> Result<[Int32], SIMDError> {
        guard a.count == b.count else {
            return .failure(.mismatchedVectorLengths(lengthA: a.count, lengthB: b.count))
        }
        
        guard !a.isEmpty else {
            return .failure(.emptyInput)
        }
        
        var result = [Int32](repeating: 0, count: a.count)
        let simdWidth = 4
        let simdCount = a.count / simdWidth
        
        for i in 0..<simdCount {
            let offset = i * simdWidth
            let va = SIMD4<Int32>(a[offset..<offset+simdWidth])
            let vb = SIMD4<Int32>(b[offset..<offset+simdWidth])
            let vr = va &+ vb
            for j in 0..<simdWidth {
                result[offset + j] = vr[j]
            }
        }
        
        for i in (simdCount * simdWidth)..<a.count {
            result[i] = a[i] + b[i]
        }
        
        return .success(result)
    }
    
    /// Adds two Int64 vectors element-wise using SIMD operations
    /// - Parameters:
    ///   - a: First vector
    ///   - b: Second vector
    /// - Returns: Result containing the sum vector or an error
    public func addVectors(_ a: [Int64], _ b: [Int64]) -> Result<[Int64], SIMDError> {
        guard a.count == b.count else {
            return .failure(.mismatchedVectorLengths(lengthA: a.count, lengthB: b.count))
        }
        
        guard !a.isEmpty else {
            return .failure(.emptyInput)
        }
        
        var result = [Int64](repeating: 0, count: a.count)
        let simdWidth = 2 // SIMD2 for 64-bit integers is more common
        let simdCount = a.count / simdWidth
        
        for i in 0..<simdCount {
            let offset = i * simdWidth
            let va = SIMD2<Int64>(a[offset..<offset+simdWidth])
            let vb = SIMD2<Int64>(b[offset..<offset+simdWidth])
            let vr = va &+ vb
            for j in 0..<simdWidth {
                result[offset + j] = vr[j]
            }
        }
        
        for i in (simdCount * simdWidth)..<a.count {
            result[i] = a[i] + b[i]
        }
        
        return .success(result)
    }
    
    /// Multiplies two Int32 vectors element-wise
    /// - Parameters:
    ///   - a: First vector
    ///   - b: Second vector
    /// - Returns: Result containing the product vector or an error
    public func multiplyVectors(_ a: [Int32], _ b: [Int32]) -> Result<[Int32], SIMDError> {
        guard a.count == b.count else {
            return .failure(.mismatchedVectorLengths(lengthA: a.count, lengthB: b.count))
        }
        
        guard !a.isEmpty else {
            return .failure(.emptyInput)
        }
        
        var result = [Int32](repeating: 0, count: a.count)
        let simdWidth = 4
        let simdCount = a.count / simdWidth
        
        for i in 0..<simdCount {
            let offset = i * simdWidth
            let va = SIMD4<Int32>(a[offset..<offset+simdWidth])
            let vb = SIMD4<Int32>(b[offset..<offset+simdWidth])
            let vr = va &* vb
            for j in 0..<simdWidth {
                result[offset + j] = vr[j]
            }
        }
        
        for i in (simdCount * simdWidth)..<a.count {
            result[i] = a[i] * b[i]
        }
        
        return .success(result)
    }
    
    /// Scales an Int32 vector by a scalar value
    /// - Parameters:
    ///   - vector: The vector to scale
    ///   - scalar: The scalar value
    /// - Returns: Result containing the scaled vector or an error
    public func scaleVector(_ vector: [Int32], by scalar: Int32) -> Result<[Int32], SIMDError> {
        guard !vector.isEmpty else {
            return .failure(.emptyInput)
        }
        
        var result = [Int32](repeating: 0, count: vector.count)
        let simdWidth = 4
        let simdCount = vector.count / simdWidth
        
        for i in 0..<simdCount {
            let offset = i * simdWidth
            let v = SIMD4<Int32>(vector[offset..<offset+simdWidth])
            let scaled = v &* scalar
            for j in 0..<simdWidth {
                result[offset + j] = scaled[j]
            }
        }
        
        for i in (simdCount * simdWidth)..<vector.count {
            result[i] = vector[i] * scalar
        }
        
        return .success(result)
    }
    
    /// Sums all elements in an Int32 vector
    /// - Parameter vector: The vector to sum
    /// - Returns: Result containing the sum or an error
    public func sumVector(_ vector: [Int32]) -> Result<Int32, SIMDError> {
        guard !vector.isEmpty else {
            return .failure(.emptyInput)
        }
        
        let simdWidth = 4
        let simdCount = vector.count / simdWidth
        var sum: Int32 = 0
        
        for i in 0..<simdCount {
            let offset = i * simdWidth
            let v = SIMD4<Int32>(vector[offset..<offset+simdWidth])
            sum += v.sum()
        }
        
        for i in (simdCount * simdWidth)..<vector.count {
            sum += vector[i]
        }
        
        return .success(sum)
    }
    
    /// Sums all elements in an Int64 vector
    /// - Parameter vector: The vector to sum
    /// - Returns: Result containing the sum or an error
    public func sumVector(_ vector: [Int64]) -> Result<Int64, SIMDError> {
        guard !vector.isEmpty else {
            return .failure(.emptyInput)
        }
        
        let simdWidth = 2
        let simdCount = vector.count / simdWidth
        var sum: Int64 = 0
        
        for i in 0..<simdCount {
            let offset = i * simdWidth
            let v = SIMD2<Int64>(vector[offset..<offset+simdWidth])
            sum += v.sum()
        }
        
        for i in (simdCount * simdWidth)..<vector.count {
            sum += vector[i]
        }
        
        return .success(sum)
    }
    
    // MARK: - Direct Integer SIMD Type Operations
    
    /// Adds two SIMD4<Int32> vectors
    /// - Parameters:
    ///   - a: First SIMD4<Int32> vector
    ///   - b: Second SIMD4<Int32> vector
    /// - Returns: Sum vector
    public func addVectors(_ a: SIMD4<Int32>, _ b: SIMD4<Int32>) -> SIMD4<Int32> {
        return a &+ b
    }
    
    /// Multiplies two SIMD4<Int32> vectors element-wise
    /// - Parameters:
    ///   - a: First SIMD4<Int32> vector
    ///   - b: Second SIMD4<Int32> vector
    /// - Returns: Element-wise product
    public func multiplyVectors(_ a: SIMD4<Int32>, _ b: SIMD4<Int32>) -> SIMD4<Int32> {
        return a &* b
    }
    
    /// Scales a SIMD4<Int32> vector by a scalar value
    /// - Parameters:
    ///   - vector: The SIMD4<Int32> vector to scale
    ///   - scalar: The scalar value
    /// - Returns: Scaled vector
    public func scaleVector(_ vector: SIMD4<Int32>, by scalar: Int32) -> SIMD4<Int32> {
        return vector &* scalar
    }
    
    /// Sums all elements in a SIMD4<Int32> vector
    /// - Parameter vector: The SIMD4<Int32> vector
    /// - Returns: Sum of all elements
    public func sumVector(_ vector: SIMD4<Int32>) -> Int32 {
        return vector.sum()
    }
    
    /// Adds two SIMD2<Int64> vectors
    /// - Parameters:
    ///   - a: First SIMD2<Int64> vector
    ///   - b: Second SIMD2<Int64> vector
    /// - Returns: Sum vector
    public func addVectors(_ a: SIMD2<Int64>, _ b: SIMD2<Int64>) -> SIMD2<Int64> {
        return a &+ b
    }
    
    /// Multiplies two SIMD2<Int64> vectors element-wise
    /// - Parameters:
    ///   - a: First SIMD2<Int64> vector
    ///   - b: Second SIMD2<Int64> vector
    /// - Returns: Element-wise product
    public func multiplyVectors(_ a: SIMD2<Int64>, _ b: SIMD2<Int64>) -> SIMD2<Int64> {
        return a &* b
    }
    
    /// Scales a SIMD2<Int64> vector by a scalar value
    /// - Parameters:
    ///   - vector: The SIMD2<Int64> vector to scale
    ///   - scalar: The scalar value
    /// - Returns: Scaled vector
    public func scaleVector(_ vector: SIMD2<Int64>, by scalar: Int64) -> SIMD2<Int64> {
        return vector &* scalar
    }
    
    /// Sums all elements in a SIMD2<Int64> vector
    /// - Parameter vector: The SIMD2<Int64> vector
    /// - Returns: Sum of all elements
    public func sumVector(_ vector: SIMD2<Int64>) -> Int64 {
        return vector.sum()
    }
    
    // MARK: - Bitwise Operations
    
    /// Performs bitwise AND on two Int32 vectors
    /// - Parameters:
    ///   - a: First vector
    ///   - b: Second vector
    /// - Returns: Result containing the bitwise AND vector or an error
    public func bitwiseAnd(_ a: [Int32], _ b: [Int32]) -> Result<[Int32], SIMDError> {
        guard a.count == b.count else {
            return .failure(.mismatchedVectorLengths(lengthA: a.count, lengthB: b.count))
        }
        
        guard !a.isEmpty else {
            return .failure(.emptyInput)
        }
        
        var result = [Int32](repeating: 0, count: a.count)
        let simdWidth = 4
        let simdCount = a.count / simdWidth
        
        for i in 0..<simdCount {
            let offset = i * simdWidth
            let va = SIMD4<Int32>(a[offset..<offset+simdWidth])
            let vb = SIMD4<Int32>(b[offset..<offset+simdWidth])
            let vr = va & vb
            for j in 0..<simdWidth {
                result[offset + j] = vr[j]
            }
        }
        
        for i in (simdCount * simdWidth)..<a.count {
            result[i] = a[i] & b[i]
        }
        
        return .success(result)
    }
    
    /// Performs bitwise OR on two Int32 vectors
    /// - Parameters:
    ///   - a: First vector
    ///   - b: Second vector
    /// - Returns: Result containing the bitwise OR vector or an error
    public func bitwiseOr(_ a: [Int32], _ b: [Int32]) -> Result<[Int32], SIMDError> {
        guard a.count == b.count else {
            return .failure(.mismatchedVectorLengths(lengthA: a.count, lengthB: b.count))
        }
        
        guard !a.isEmpty else {
            return .failure(.emptyInput)
        }
        
        var result = [Int32](repeating: 0, count: a.count)
        let simdWidth = 4
        let simdCount = a.count / simdWidth
        
        for i in 0..<simdCount {
            let offset = i * simdWidth
            let va = SIMD4<Int32>(a[offset..<offset+simdWidth])
            let vb = SIMD4<Int32>(b[offset..<offset+simdWidth])
            let vr = va | vb
            for j in 0..<simdWidth {
                result[offset + j] = vr[j]
            }
        }
        
        for i in (simdCount * simdWidth)..<a.count {
            result[i] = a[i] | b[i]
        }
        
        return .success(result)
    }
    
    /// Performs bitwise XOR on two Int32 vectors
    /// - Parameters:
    ///   - a: First vector
    ///   - b: Second vector
    /// - Returns: Result containing the bitwise XOR vector or an error
    public func bitwiseXor(_ a: [Int32], _ b: [Int32]) -> Result<[Int32], SIMDError> {
        guard a.count == b.count else {
            return .failure(.mismatchedVectorLengths(lengthA: a.count, lengthB: b.count))
        }
        
        guard !a.isEmpty else {
            return .failure(.emptyInput)
        }
        
        var result = [Int32](repeating: 0, count: a.count)
        let simdWidth = 4
        let simdCount = a.count / simdWidth
        
        for i in 0..<simdCount {
            let offset = i * simdWidth
            let va = SIMD4<Int32>(a[offset..<offset+simdWidth])
            let vb = SIMD4<Int32>(b[offset..<offset+simdWidth])
            let vr = va ^ vb
            for j in 0..<simdWidth {
                result[offset + j] = vr[j]
            }
        }
        
        for i in (simdCount * simdWidth)..<a.count {
            result[i] = a[i] ^ b[i]
        }
        
        return .success(result)
    }
}