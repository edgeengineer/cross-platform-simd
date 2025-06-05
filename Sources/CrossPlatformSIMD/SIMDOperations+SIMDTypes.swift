#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif
import simd

extension SIMDOperations {
    
    // MARK: - Direct SIMD Type APIs
    
    /// Adds two SIMD4<Float> vectors
    /// - Parameters:
    ///   - a: First SIMD4<Float> vector
    ///   - b: Second SIMD4<Float> vector
    /// - Returns: Result containing the sum vector
    public func addVectors(_ a: SIMD4<Float>, _ b: SIMD4<Float>) -> SIMD4<Float> {
        return a + b
    }
    
    /// Adds two SIMD4<Double> vectors
    /// - Parameters:
    ///   - a: First SIMD4<Double> vector
    ///   - b: Second SIMD4<Double> vector
    /// - Returns: Result containing the sum vector
    public func addVectors(_ a: SIMD4<Double>, _ b: SIMD4<Double>) -> SIMD4<Double> {
        return a + b
    }
    
    /// Computes the dot product of two SIMD4<Float> vectors
    /// - Parameters:
    ///   - a: First SIMD4<Float> vector
    ///   - b: Second SIMD4<Float> vector
    /// - Returns: The dot product as Float
    public func dotProduct(_ a: SIMD4<Float>, _ b: SIMD4<Float>) -> Float {
        let product = a * b
        return product.sum()
    }
    
    /// Computes the dot product of two SIMD4<Double> vectors
    /// - Parameters:
    ///   - a: First SIMD4<Double> vector
    ///   - b: Second SIMD4<Double> vector
    /// - Returns: The dot product as Double
    public func dotProduct(_ a: SIMD4<Double>, _ b: SIMD4<Double>) -> Double {
        let product = a * b
        return product.sum()
    }
    
    /// Multiplies two SIMD4<Float> vectors element-wise
    /// - Parameters:
    ///   - a: First SIMD4<Float> vector
    ///   - b: Second SIMD4<Float> vector
    /// - Returns: Element-wise product
    public func multiplyVectors(_ a: SIMD4<Float>, _ b: SIMD4<Float>) -> SIMD4<Float> {
        return a * b
    }
    
    /// Multiplies two SIMD4<Double> vectors element-wise
    /// - Parameters:
    ///   - a: First SIMD4<Double> vector
    ///   - b: Second SIMD4<Double> vector
    /// - Returns: Element-wise product
    public func multiplyVectors(_ a: SIMD4<Double>, _ b: SIMD4<Double>) -> SIMD4<Double> {
        return a * b
    }
    
    /// Scales a SIMD4<Float> vector by a scalar value
    /// - Parameters:
    ///   - vector: The SIMD4<Float> vector to scale
    ///   - scalar: The scalar value
    /// - Returns: Scaled vector
    public func scaleVector(_ vector: SIMD4<Float>, by scalar: Float) -> SIMD4<Float> {
        return vector * scalar
    }
    
    /// Scales a SIMD4<Double> vector by a scalar value
    /// - Parameters:
    ///   - vector: The SIMD4<Double> vector to scale
    ///   - scalar: The scalar value
    /// - Returns: Scaled vector
    public func scaleVector(_ vector: SIMD4<Double>, by scalar: Double) -> SIMD4<Double> {
        return vector * scalar
    }
    
    /// Sums all elements in a SIMD4<Float> vector
    /// - Parameter vector: The SIMD4<Float> vector
    /// - Returns: Sum of all elements
    public func sumVector(_ vector: SIMD4<Float>) -> Float {
        return vector.sum()
    }
    
    /// Sums all elements in a SIMD4<Double> vector
    /// - Parameter vector: The SIMD4<Double> vector
    /// - Returns: Sum of all elements
    public func sumVector(_ vector: SIMD4<Double>) -> Double {
        return vector.sum()
    }
    
    // MARK: - Conversion Helpers
    
    /// Converts an array to chunks of SIMD4 vectors
    /// - Parameter array: The input array
    /// - Returns: Array of SIMD4 vectors and remaining elements
    public func toSIMD4Chunks<T: SIMDScalar>(_ array: [T]) -> (chunks: [SIMD4<T>], remainder: ArraySlice<T>) {
        let chunkCount = array.count / 4
        var chunks: [SIMD4<T>] = []
        
        for i in 0..<chunkCount {
            let start = i * 4
            let end = start + 4
            let chunk = SIMD4<T>(array[start..<end])
            chunks.append(chunk)
        }
        
        let remainderStart = chunkCount * 4
        let remainder = array[remainderStart...]
        
        return (chunks, remainder)
    }
    
    /// Converts SIMD4 chunks back to a flat array
    /// - Parameters:
    ///   - chunks: Array of SIMD4 vectors
    ///   - remainder: Remaining elements
    /// - Returns: Flattened array
    public func fromSIMD4Chunks<T: SIMDScalar>(_ chunks: [SIMD4<T>], remainder: ArraySlice<T>) -> [T] {
        var result: [T] = []
        result.reserveCapacity(chunks.count * 4 + remainder.count)
        
        for chunk in chunks {
            result.append(contentsOf: [chunk[0], chunk[1], chunk[2], chunk[3]])
        }
        
        result.append(contentsOf: remainder)
        return result
    }
}