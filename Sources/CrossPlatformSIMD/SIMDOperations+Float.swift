#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif
import simd

extension SIMDOperations {
    
    // MARK: - Float Operations
    
    /// Adds two Float vectors element-wise using SIMD operations
    /// - Parameters:
    ///   - a: First vector
    ///   - b: Second vector
    /// - Returns: Result containing the sum vector or an error
    public func addVectors(_ a: [Float], _ b: [Float]) -> Result<[Float], SIMDError> {
        guard a.count == b.count else {
            return .failure(.mismatchedVectorLengths(lengthA: a.count, lengthB: b.count))
        }
        
        guard !a.isEmpty else {
            return .failure(.emptyInput)
        }
        
        var result = [Float](repeating: 0, count: a.count)
        let simdWidth = 4
        let simdCount = a.count / simdWidth
        
        for i in 0..<simdCount {
            let offset = i * simdWidth
            let va = SIMD4<Float>(a[offset..<offset+simdWidth])
            let vb = SIMD4<Float>(b[offset..<offset+simdWidth])
            let vr = va + vb
            for j in 0..<simdWidth {
                result[offset + j] = vr[j]
            }
        }
        
        for i in (simdCount * simdWidth)..<a.count {
            result[i] = a[i] + b[i]
        }
        
        return .success(result)
    }
    
    /// Computes the dot product of two Float vectors
    public func dotProduct(_ a: [Float], _ b: [Float]) -> Result<Float, SIMDError> {
        guard a.count == b.count else {
            return .failure(.mismatchedVectorLengths(lengthA: a.count, lengthB: b.count))
        }
        
        guard !a.isEmpty else {
            return .failure(.emptyInput)
        }
        
        let simdWidth = 4
        let simdCount = a.count / simdWidth
        var sum: Float = 0
        
        for i in 0..<simdCount {
            let offset = i * simdWidth
            let va = SIMD4<Float>(a[offset..<offset+simdWidth])
            let vb = SIMD4<Float>(b[offset..<offset+simdWidth])
            let product = va * vb
            sum += product.sum()
        }
        
        for i in (simdCount * simdWidth)..<a.count {
            sum += a[i] * b[i]
        }
        
        return .success(sum)
    }
    
    /// Multiplies two Float vectors element-wise
    public func multiplyVectors(_ a: [Float], _ b: [Float]) -> Result<[Float], SIMDError> {
        guard a.count == b.count else {
            return .failure(.mismatchedVectorLengths(lengthA: a.count, lengthB: b.count))
        }
        
        guard !a.isEmpty else {
            return .failure(.emptyInput)
        }
        
        var result = [Float](repeating: 0, count: a.count)
        let simdWidth = 4
        let simdCount = a.count / simdWidth
        
        for i in 0..<simdCount {
            let offset = i * simdWidth
            let va = SIMD4<Float>(a[offset..<offset+simdWidth])
            let vb = SIMD4<Float>(b[offset..<offset+simdWidth])
            let vr = va * vb
            for j in 0..<simdWidth {
                result[offset + j] = vr[j]
            }
        }
        
        for i in (simdCount * simdWidth)..<a.count {
            result[i] = a[i] * b[i]
        }
        
        return .success(result)
    }
    
    /// Scales a Float vector by a scalar value
    public func scaleVector(_ vector: [Float], by scalar: Float) -> Result<[Float], SIMDError> {
        guard !vector.isEmpty else {
            return .failure(.emptyInput)
        }
        
        var result = [Float](repeating: 0, count: vector.count)
        let simdWidth = 4
        let simdCount = vector.count / simdWidth
        
        for i in 0..<simdCount {
            let offset = i * simdWidth
            let v = SIMD4<Float>(vector[offset..<offset+simdWidth])
            let scaled = v * scalar
            for j in 0..<simdWidth {
                result[offset + j] = scaled[j]
            }
        }
        
        for i in (simdCount * simdWidth)..<vector.count {
            result[i] = vector[i] * scalar
        }
        
        return .success(result)
    }
    
    /// Sums all elements in a Float vector
    public func sumVector(_ vector: [Float]) -> Result<Float, SIMDError> {
        guard !vector.isEmpty else {
            return .failure(.emptyInput)
        }
        
        let simdWidth = 4
        let simdCount = vector.count / simdWidth
        var sum: Float = 0
        
        for i in 0..<simdCount {
            let offset = i * simdWidth
            let v = SIMD4<Float>(vector[offset..<offset+simdWidth])
            sum += v.sum()
        }
        
        for i in (simdCount * simdWidth)..<vector.count {
            sum += vector[i]
        }
        
        return .success(sum)
    }
    
    /// Performs matrix multiplication on Float matrices
    public func matrixMultiply(_ a: [[Float]], _ b: [[Float]]) -> Result<[[Float]], SIMDError> {
        let m = a.count
        guard m > 0 else {
            return .failure(.emptyInput)
        }
        
        let p = a[0].count
        guard p > 0 else {
            return .failure(.emptyInput)
        }
        
        guard b.count == p else {
            return .failure(.invalidMatrixDimensions(message: "Matrix A columns (\(p)) must equal Matrix B rows (\(b.count))"))
        }
        
        let n = b[0].count
        guard n > 0 else {
            return .failure(.emptyInput)
        }
        
        var result = [[Float]](repeating: [Float](repeating: 0, count: n), count: m)
        
        for i in 0..<m {
            for j in 0..<n {
                var sum: Float = 0
                let simdWidth = 4
                let simdCount = p / simdWidth
                
                for k in 0..<simdCount {
                    let offset = k * simdWidth
                    var aValues = SIMD4<Float>()
                    var bValues = SIMD4<Float>()
                    
                    for idx in 0..<simdWidth {
                        if offset + idx < p {
                            aValues[idx] = a[i][offset + idx]
                            bValues[idx] = b[offset + idx][j]
                        }
                    }
                    
                    let product = aValues * bValues
                    sum += product.sum()
                }
                
                for k in (simdCount * simdWidth)..<p {
                    sum += a[i][k] * b[k][j]
                }
                
                result[i][j] = sum
            }
        }
        
        return .success(result)
    }
}