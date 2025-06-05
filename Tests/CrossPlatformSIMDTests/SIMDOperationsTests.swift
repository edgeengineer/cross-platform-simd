import Testing
@testable import CrossPlatformSIMD

struct SIMDOperationsTests {
    let simd = SIMDOperations()
    
    @Test func testSIMDOperationsInitialization() {
        let operations = SIMDOperations()
        // Test that initialization succeeds and object is usable
        let testVector: [Float] = [1.0, 2.0, 3.0, 4.0]
        
        switch operations.sumVector(testVector) {
        case .success(let result):
            #expect(result == 10.0)
        case .failure(let error):
            Issue.record("Initialization test failed: \(error)")
        }
    }
    
    @Test func testAddVectorsFloat() {
        let a: [Float] = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0]
        let b: [Float] = [8.0, 7.0, 6.0, 5.0, 4.0, 3.0, 2.0, 1.0]
        let expected: [Float] = [9.0, 9.0, 9.0, 9.0, 9.0, 9.0, 9.0, 9.0]
        
        switch simd.addVectors(a, b) {
        case .success(let result):
            #expect(result == expected)
        case .failure(let error):
            Issue.record("Unexpected error: \(error)")
        }
    }
    
    @Test func testAddVectorsDouble() {
        let a: [Double] = [1.0, 2.0, 3.0, 4.0, 5.0]
        let b: [Double] = [5.0, 4.0, 3.0, 2.0, 1.0]
        let expected: [Double] = [6.0, 6.0, 6.0, 6.0, 6.0]
        
        switch simd.addVectors(a, b) {
        case .success(let result):
            #expect(result == expected)
        case .failure(let error):
            Issue.record("Unexpected error: \(error)")
        }
    }
    
    @Test func testDotProductFloat() {
        let a: [Float] = [1.0, 2.0, 3.0, 4.0]
        let b: [Float] = [4.0, 3.0, 2.0, 1.0]
        let expected: Float = 20.0
        
        switch simd.dotProduct(a, b) {
        case .success(let result):
            #expect(result == expected)
        case .failure(let error):
            Issue.record("Unexpected error: \(error)")
        }
    }
    
    @Test func testDotProductDouble() {
        let a: [Double] = [1.0, 2.0, 3.0, 4.0, 5.0]
        let b: [Double] = [2.0, 2.0, 2.0, 2.0, 2.0]
        let expected: Double = 30.0
        
        switch simd.dotProduct(a, b) {
        case .success(let result):
            #expect(result == expected)
        case .failure(let error):
            Issue.record("Unexpected error: \(error)")
        }
    }
    
    @Test func testMultiplyVectorsFloat() {
        let a: [Float] = [2.0, 3.0, 4.0, 5.0]
        let b: [Float] = [2.0, 2.0, 2.0, 2.0]
        let expected: [Float] = [4.0, 6.0, 8.0, 10.0]
        
        switch simd.multiplyVectors(a, b) {
        case .success(let result):
            #expect(result == expected)
        case .failure(let error):
            Issue.record("Unexpected error: \(error)")
        }
    }
    
    @Test func testScaleVectorFloat() {
        let vector: [Float] = [1.0, 2.0, 3.0, 4.0, 5.0]
        let scalar: Float = 2.5
        let expected: [Float] = [2.5, 5.0, 7.5, 10.0, 12.5]
        
        switch simd.scaleVector(vector, by: scalar) {
        case .success(let result):
            #expect(result == expected)
        case .failure(let error):
            Issue.record("Unexpected error: \(error)")
        }
    }
    
    @Test func testSumVectorFloat() {
        let vector: [Float] = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0]
        let expected: Float = 36.0
        
        switch simd.sumVector(vector) {
        case .success(let result):
            #expect(result == expected)
        case .failure(let error):
            Issue.record("Unexpected error: \(error)")
        }
    }
    
    @Test func testSumVectorDouble() {
        let vector: [Double] = [1.5, 2.5, 3.5, 4.5, 5.5]
        let expected: Double = 17.5
        
        switch simd.sumVector(vector) {
        case .success(let result):
            #expect(result == expected)
        case .failure(let error):
            Issue.record("Unexpected error: \(error)")
        }
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
        
        switch simd.matrixMultiply(a, b) {
        case .success(let result):
            #expect(result == expected)
        case .failure(let error):
            Issue.record("Unexpected error: \(error)")
        }
    }
    
    @Test func testLargeVectorOperations() {
        let size = 1000
        let a = [Float](repeating: 1.0, count: size)
        let b = [Float](repeating: 2.0, count: size)
        
        switch simd.addVectors(a, b) {
        case .success(let addResult):
            #expect(addResult.allSatisfy { $0 == 3.0 })
        case .failure(let error):
            Issue.record("Unexpected error in add: \(error)")
        }
        
        switch simd.multiplyVectors(a, b) {
        case .success(let multiplyResult):
            #expect(multiplyResult.allSatisfy { $0 == 2.0 })
        case .failure(let error):
            Issue.record("Unexpected error in multiply: \(error)")
        }
        
        switch simd.scaleVector(a, by: 5.0) {
        case .success(let scaleResult):
            #expect(scaleResult.allSatisfy { $0 == 5.0 })
        case .failure(let error):
            Issue.record("Unexpected error in scale: \(error)")
        }
        
        switch simd.dotProduct(a, b) {
        case .success(let dotResult):
            #expect(dotResult == Float(size * 2))
        case .failure(let error):
            Issue.record("Unexpected error in dot product: \(error)")
        }
        
        switch simd.sumVector(a) {
        case .success(let sumResult):
            #expect(sumResult == Float(size))
        case .failure(let error):
            Issue.record("Unexpected error in sum: \(error)")
        }
    }
    
    @Test func testUnalignedVectorSizes() {
        let a: [Float] = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0]
        let b: [Float] = [7.0, 6.0, 5.0, 4.0, 3.0, 2.0, 1.0]
        let expected: [Float] = [8.0, 8.0, 8.0, 8.0, 8.0, 8.0, 8.0]
        
        switch simd.addVectors(a, b) {
        case .success(let result):
            #expect(result == expected)
        case .failure(let error):
            Issue.record("Unexpected error: \(error)")
        }
    }
}