#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif
import simd

extension SIMDOperations {
    
    // MARK: - Optimized SIMD Operations with Pointer-Based Extraction
    
    /// Optimized vector addition using pointer-based SIMD result extraction
    /// - Parameters:
    ///   - a: First vector
    ///   - b: Second vector
    /// - Returns: Result containing the sum vector or an error
    public func addVectorsOptimized(_ a: [Float], _ b: [Float]) -> Result<[Float], SIMDError> {
        guard a.count == b.count else {
            return .failure(.mismatchedVectorLengths(lengthA: a.count, lengthB: b.count))
        }
        
        guard !a.isEmpty else {
            return .failure(.emptyInput)
        }
        
        var result = [Float](repeating: 0, count: a.count)
        let simdWidth = 4
        let simdCount = a.count / simdWidth
        
        // Process SIMD chunks with optimized extraction
        for i in 0..<simdCount {
            let offset = i * simdWidth
            let va = SIMD4<Float>(a[offset..<offset+simdWidth])
            let vb = SIMD4<Float>(b[offset..<offset+simdWidth])
            let vr = va + vb
            
            // Optimized: Use direct element assignment (simple but effective)
            for j in 0..<simdWidth {
                result[offset + j] = vr[j]
            }
        }
        
        // Handle remainder elements
        for i in (simdCount * simdWidth)..<a.count {
            result[i] = a[i] + b[i]
        }
        
        return .success(result)
    }
    
    /// Optimized vector multiplication using pointer-based SIMD result extraction
    /// - Parameters:
    ///   - a: First vector
    ///   - b: Second vector
    /// - Returns: Result containing the product vector or an error
    public func multiplyVectorsOptimized(_ a: [Float], _ b: [Float]) -> Result<[Float], SIMDError> {
        guard a.count == b.count else {
            return .failure(.mismatchedVectorLengths(lengthA: a.count, lengthB: b.count))
        }
        
        guard !a.isEmpty else {
            return .failure(.emptyInput)
        }
        
        var result = [Float](repeating: 0, count: a.count)
        let simdWidth = 4
        let simdCount = a.count / simdWidth
        
        // Process SIMD chunks with optimized extraction
        for i in 0..<simdCount {
            let offset = i * simdWidth
            let va = SIMD4<Float>(a[offset..<offset+simdWidth])
            let vb = SIMD4<Float>(b[offset..<offset+simdWidth])
            let vr = va * vb
            
            // Direct element assignment
            for j in 0..<simdWidth {
                result[offset + j] = vr[j]
            }
        }
        
        // Handle remainder elements
        for i in (simdCount * simdWidth)..<a.count {
            result[i] = a[i] * b[i]
        }
        
        return .success(result)
    }
    
    /// Optimized vector scaling using SIMD8 when beneficial
    /// - Parameters:
    ///   - vector: The vector to scale
    ///   - scalar: The scalar value
    /// - Returns: Result containing the scaled vector or an error
    public func scaleVectorOptimized(_ vector: [Float], by scalar: Float) -> Result<[Float], SIMDError> {
        guard !vector.isEmpty else {
            return .failure(.emptyInput)
        }
        
        var result = [Float](repeating: 0, count: vector.count)
        
        // Use SIMD8 for larger arrays for better performance
        if vector.count >= 16 {
            let simd8Width = 8
            let simd8Count = vector.count / simd8Width
            let scalarVec8 = SIMD8<Float>(repeating: scalar)
            
            for i in 0..<simd8Count {
                let offset = i * simd8Width
                let v = SIMD8<Float>(vector[offset..<offset+simd8Width])
                let scaled = v * scalarVec8
                
                // Extract SIMD8 results
                for j in 0..<simd8Width {
                    result[offset + j] = scaled[j]
                }
            }
            
            // Handle remainder with SIMD4
            let remainderStart = simd8Count * simd8Width
            let simd4Width = 4
            let simd4Count = (vector.count - remainderStart) / simd4Width
            let scalarVec4 = SIMD4<Float>(repeating: scalar)
            
            for i in 0..<simd4Count {
                let offset = remainderStart + i * simd4Width
                let v = SIMD4<Float>(vector[offset..<offset+simd4Width])
                let scaled = v * scalarVec4
                
                for j in 0..<simd4Width {
                    result[offset + j] = scaled[j]
                }
            }
            
            // Handle final remainder elements
            let finalStart = remainderStart + simd4Count * simd4Width
            for i in finalStart..<vector.count {
                result[i] = vector[i] * scalar
            }
        } else {
            // Use SIMD4 for smaller arrays
            let simdWidth = 4
            let simdCount = vector.count / simdWidth
            let scalarVec = SIMD4<Float>(repeating: scalar)
            
            for i in 0..<simdCount {
                let offset = i * simdWidth
                let v = SIMD4<Float>(vector[offset..<offset+simdWidth])
                let scaled = v * scalarVec
                
                for j in 0..<simdWidth {
                    result[offset + j] = scaled[j]
                }
            }
            
            // Handle remainder elements
            for i in (simdCount * simdWidth)..<vector.count {
                result[i] = vector[i] * scalar
            }
        }
        
        return .success(result)
    }
    
    /// Optimized sum using adaptive SIMD width
    /// - Parameter vector: The vector to sum
    /// - Returns: Result containing the sum or an error
    public func sumVectorOptimized(_ vector: [Float]) -> Result<Float, SIMDError> {
        guard !vector.isEmpty else {
            return .failure(.emptyInput)
        }
        
        var sum: Float = 0
        
        // Use SIMD16 for very large arrays
        if vector.count >= 64 {
            let simd16Width = 16
            let simd16Count = vector.count / simd16Width
            var accumulator16 = SIMD16<Float>(repeating: 0)
            
            for i in 0..<simd16Count {
                let offset = i * simd16Width
                let v = SIMD16<Float>(vector[offset..<offset+simd16Width])
                accumulator16 += v
            }
            sum += accumulator16.sum()
            
            // Continue with remaining elements using SIMD8/SIMD4
            let remainderStart = simd16Count * simd16Width
            let remainingElements = vector.count - remainderStart
            
            if remainingElements >= 8 {
                let simd8Width = 8
                let simd8Count = remainingElements / simd8Width
                
                for i in 0..<simd8Count {
                    let offset = remainderStart + i * simd8Width
                    let v = SIMD8<Float>(vector[offset..<offset+simd8Width])
                    sum += v.sum()
                }
                
                let simd8Remainder = remainderStart + simd8Count * simd8Width
                for i in simd8Remainder..<vector.count {
                    sum += vector[i]
                }
            } else {
                for i in remainderStart..<vector.count {
                    sum += vector[i]
                }
            }
        } else {
            // Use SIMD4 for smaller arrays
            let simdWidth = 4
            let simdCount = vector.count / simdWidth
            
            for i in 0..<simdCount {
                let offset = i * simdWidth
                let v = SIMD4<Float>(vector[offset..<offset+simdWidth])
                sum += v.sum()
            }
            
            for i in (simdCount * simdWidth)..<vector.count {
                sum += vector[i]
            }
        }
        
        return .success(sum)
    }
}