import Testing
@testable import CrossPlatformSIMD

struct SIMDOperationsTests {
    let simd = SIMDOperations()
    
    @Test func testAddVectorsFloat() {
        let a: [Float] = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0]
        let b: [Float] = [8.0, 7.0, 6.0, 5.0, 4.0, 3.0, 2.0, 1.0]
        let expected: [Float] = [9.0, 9.0, 9.0, 9.0, 9.0, 9.0, 9.0, 9.0]
        
        let result = simd.addVectors(a, b)
        
        #expect(result == expected)
    }
    
    @Test func testAddVectorsDouble() {
        let a: [Double] = [1.0, 2.0, 3.0, 4.0, 5.0]
        let b: [Double] = [5.0, 4.0, 3.0, 2.0, 1.0]
        let expected: [Double] = [6.0, 6.0, 6.0, 6.0, 6.0]
        
        let result = simd.addVectors(a, b)
        
        #expect(result == expected)
    }
    
    @Test func testDotProductFloat() {
        let a: [Float] = [1.0, 2.0, 3.0, 4.0]
        let b: [Float] = [4.0, 3.0, 2.0, 1.0]
        let expected: Float = 20.0
        
        let result = simd.dotProduct(a, b)
        
        #expect(result == expected)
    }
    
    @Test func testDotProductDouble() {
        let a: [Double] = [1.0, 2.0, 3.0, 4.0, 5.0]
        let b: [Double] = [2.0, 2.0, 2.0, 2.0, 2.0]
        let expected: Double = 30.0
        
        let result = simd.dotProduct(a, b)
        
        #expect(result == expected)
    }
    
    @Test func testMultiplyVectorsFloat() {
        let a: [Float] = [2.0, 3.0, 4.0, 5.0]
        let b: [Float] = [2.0, 2.0, 2.0, 2.0]
        let expected: [Float] = [4.0, 6.0, 8.0, 10.0]
        
        let result = simd.multiplyVectors(a, b)
        
        #expect(result == expected)
    }
    
    @Test func testScaleVectorFloat() {
        let vector: [Float] = [1.0, 2.0, 3.0, 4.0, 5.0]
        let scalar: Float = 2.5
        let expected: [Float] = [2.5, 5.0, 7.5, 10.0, 12.5]
        
        let result = simd.scaleVector(vector, by: scalar)
        
        #expect(result == expected)
    }
    
    @Test func testSumVectorFloat() {
        let vector: [Float] = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0]
        let expected: Float = 36.0
        
        let result = simd.sumVector(vector)
        
        #expect(result == expected)
    }
    
    @Test func testSumVectorDouble() {
        let vector: [Double] = [1.5, 2.5, 3.5, 4.5, 5.5]
        let expected: Double = 17.5
        
        let result = simd.sumVector(vector)
        
        #expect(result == expected)
    }
    
    @Test func testMatrixMultiply() {
        let a: [[Float]] = [
            [1.0, 2.0],
            [3.0, 4.0]
        ]
        let b: [[Float]] = [
            [5.0, 6.0],
            [7.0, 8.0]
        ]
        let expected: [[Float]] = [
            [19.0, 22.0],
            [43.0, 50.0]
        ]
        
        let result = simd.matrixMultiply(a, b)
        
        #expect(result == expected)
    }
    
    @Test func testLargeVectorOperations() {
        let size = 1000
        let a = [Float](repeating: 1.0, count: size)
        let b = [Float](repeating: 2.0, count: size)
        
        let addResult = simd.addVectors(a, b)
        #expect(addResult.allSatisfy { $0 == 3.0 })
        
        let multiplyResult = simd.multiplyVectors(a, b)
        #expect(multiplyResult.allSatisfy { $0 == 2.0 })
        
        let scaleResult = simd.scaleVector(a, by: 5.0)
        #expect(scaleResult.allSatisfy { $0 == 5.0 })
        
        let dotResult = simd.dotProduct(a, b)
        #expect(dotResult == Float(size * 2))
        
        let sumResult = simd.sumVector(a)
        #expect(sumResult == Float(size))
    }
    
    @Test func testUnalignedVectorSizes() {
        let a: [Float] = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0]
        let b: [Float] = [7.0, 6.0, 5.0, 4.0, 3.0, 2.0, 1.0]
        let expected: [Float] = [8.0, 8.0, 8.0, 8.0, 8.0, 8.0, 8.0]
        
        let result = simd.addVectors(a, b)
        
        #expect(result == expected)
    }
}