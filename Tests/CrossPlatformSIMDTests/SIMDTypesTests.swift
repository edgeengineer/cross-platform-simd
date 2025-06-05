import Testing
import simd
@testable import CrossPlatformSIMD

struct SIMDTypesTests {
    let simd = SIMDOperations()
    
    // MARK: - SIMD4<Float> Tests
    
    @Test func testSIMD4FloatAddition() {
        let a = SIMD4<Float>(1.0, 2.0, 3.0, 4.0)
        let b = SIMD4<Float>(5.0, 6.0, 7.0, 8.0)
        let expected = SIMD4<Float>(6.0, 8.0, 10.0, 12.0)
        
        let result = simd.addVectors(a, b)
        
        #expect(result == expected)
    }
    
    @Test func testSIMD4FloatDotProduct() {
        let a = SIMD4<Float>(1.0, 2.0, 3.0, 4.0)
        let b = SIMD4<Float>(5.0, 6.0, 7.0, 8.0)
        let expected: Float = 70.0
        
        let result = simd.dotProduct(a, b)
        
        #expect(result == expected)
    }
    
    @Test func testSIMD4FloatMultiplication() {
        let a = SIMD4<Float>(1.0, 2.0, 3.0, 4.0)
        let b = SIMD4<Float>(5.0, 6.0, 7.0, 8.0)
        let expected = SIMD4<Float>(5.0, 12.0, 21.0, 32.0)
        
        let result = simd.multiplyVectors(a, b)
        
        #expect(result == expected)
    }
    
    @Test func testSIMD4FloatScaling() {
        let vector = SIMD4<Float>(1.0, 2.0, 3.0, 4.0)
        let scalar: Float = 2.5
        let expected = SIMD4<Float>(2.5, 5.0, 7.5, 10.0)
        
        let result = simd.scaleVector(vector, by: scalar)
        
        #expect(result == expected)
    }
    
    @Test func testSIMD4FloatSum() {
        let vector = SIMD4<Float>(1.0, 2.0, 3.0, 4.0)
        let expected: Float = 10.0
        
        let result = simd.sumVector(vector)
        
        #expect(result == expected)
    }
    
    // MARK: - SIMD4<Double> Tests
    
    @Test func testSIMD4DoubleAddition() {
        let a = SIMD4<Double>(1.0, 2.0, 3.0, 4.0)
        let b = SIMD4<Double>(5.0, 6.0, 7.0, 8.0)
        let expected = SIMD4<Double>(6.0, 8.0, 10.0, 12.0)
        
        let result = simd.addVectors(a, b)
        
        #expect(result == expected)
    }
    
    @Test func testSIMD4DoubleDotProduct() {
        let a = SIMD4<Double>(1.0, 2.0, 3.0, 4.0)
        let b = SIMD4<Double>(5.0, 6.0, 7.0, 8.0)
        let expected: Double = 70.0
        
        let result = simd.dotProduct(a, b)
        
        #expect(result == expected)
    }
    
    @Test func testSIMD4DoubleMultiplication() {
        let a = SIMD4<Double>(1.0, 2.0, 3.0, 4.0)
        let b = SIMD4<Double>(5.0, 6.0, 7.0, 8.0)
        let expected = SIMD4<Double>(5.0, 12.0, 21.0, 32.0)
        
        let result = simd.multiplyVectors(a, b)
        
        #expect(result == expected)
    }
    
    @Test func testSIMD4DoubleScaling() {
        let vector = SIMD4<Double>(1.0, 2.0, 3.0, 4.0)
        let scalar: Double = 2.5
        let expected = SIMD4<Double>(2.5, 5.0, 7.5, 10.0)
        
        let result = simd.scaleVector(vector, by: scalar)
        
        #expect(result == expected)
    }
    
    @Test func testSIMD4DoubleSum() {
        let vector = SIMD4<Double>(1.0, 2.0, 3.0, 4.0)
        let expected: Double = 10.0
        
        let result = simd.sumVector(vector)
        
        #expect(result == expected)
    }
    
    // MARK: - Conversion Helper Tests
    
    @Test func testToSIMD4ChunksFloat() {
        let array: [Float] = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0]
        
        let (chunks, remainder) = simd.toSIMD4Chunks(array)
        
        #expect(chunks.count == 2)
        #expect(chunks[0] == SIMD4<Float>(1.0, 2.0, 3.0, 4.0))
        #expect(chunks[1] == SIMD4<Float>(5.0, 6.0, 7.0, 8.0))
        #expect(Array(remainder) == [9.0])
    }
    
    @Test func testFromSIMD4ChunksFloat() {
        let chunks = [
            SIMD4<Float>(1.0, 2.0, 3.0, 4.0),
            SIMD4<Float>(5.0, 6.0, 7.0, 8.0)
        ]
        let remainder: ArraySlice<Float> = [9.0]
        let expected: [Float] = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0]
        
        let result = simd.fromSIMD4Chunks(chunks, remainder: remainder)
        
        #expect(result == expected)
    }
    
    @Test func testToSIMD4ChunksDouble() {
        let array: [Double] = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0]
        
        let (chunks, remainder) = simd.toSIMD4Chunks(array)
        
        #expect(chunks.count == 1)
        #expect(chunks[0] == SIMD4<Double>(1.0, 2.0, 3.0, 4.0))
        #expect(Array(remainder) == [5.0, 6.0])
    }
    
    @Test func testFromSIMD4ChunksDouble() {
        let chunks = [SIMD4<Double>(1.0, 2.0, 3.0, 4.0)]
        let remainder: ArraySlice<Double> = [5.0, 6.0]
        let expected: [Double] = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0]
        
        let result = simd.fromSIMD4Chunks(chunks, remainder: remainder)
        
        #expect(result == expected)
    }
    
    @Test func testRoundTripConversion() {
        let original: [Float] = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 11.0]
        
        let (chunks, remainder) = simd.toSIMD4Chunks(original)
        let result = simd.fromSIMD4Chunks(chunks, remainder: remainder)
        
        #expect(result == original)
    }
}