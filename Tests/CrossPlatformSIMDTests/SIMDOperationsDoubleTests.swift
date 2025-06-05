import Testing
@testable import CrossPlatformSIMD

struct SIMDOperationsDoubleTests {
    let simd = SIMDOperations()
    
    @Test func testMultiplyVectorsDouble() {
        let a: [Double] = [2.0, 3.0, 4.0, 5.0, 6.0]
        let b: [Double] = [2.0, 2.0, 2.0, 2.0, 2.0]
        let expected: [Double] = [4.0, 6.0, 8.0, 10.0, 12.0]
        
        switch simd.multiplyVectors(a, b) {
        case .success(let result):
            #expect(result == expected)
        case .failure(let error):
            Issue.record("Unexpected error: \(error)")
        }
    }
    
    @Test func testScaleVectorDouble() {
        let vector: [Double] = [1.0, 2.0, 3.0, 4.0, 5.0]
        let scalar: Double = 2.5
        let expected: [Double] = [2.5, 5.0, 7.5, 10.0, 12.5]
        
        switch simd.scaleVector(vector, by: scalar) {
        case .success(let result):
            #expect(result == expected)
        case .failure(let error):
            Issue.record("Unexpected error: \(error)")
        }
    }
    
    @Test func testMatrixMultiplyDouble() {
        let a: [[Double]] = [
            [1.0, 2.0, 3.0],
            [4.0, 5.0, 6.0]
        ]
        let b: [[Double]] = [
            [7.0, 8.0],
            [9.0, 10.0],
            [11.0, 12.0]
        ]
        let expected: [[Double]] = [
            [58.0, 64.0],
            [139.0, 154.0]
        ]
        
        switch simd.matrixMultiply(a, b) {
        case .success(let result):
            #expect(result == expected)
        case .failure(let error):
            Issue.record("Unexpected error: \(error)")
        }
    }
    
    @Test func testLargeVectorOperationsDouble() {
        let size = 1001 // Odd size to test unaligned
        let a = [Double](repeating: 1.5, count: size)
        let b = [Double](repeating: 2.5, count: size)
        
        switch simd.addVectors(a, b) {
        case .success(let addResult):
            #expect(addResult.allSatisfy { $0 == 4.0 })
        case .failure(let error):
            Issue.record("Unexpected error in add: \(error)")
        }
        
        switch simd.multiplyVectors(a, b) {
        case .success(let multiplyResult):
            #expect(multiplyResult.allSatisfy { $0 == 3.75 })
        case .failure(let error):
            Issue.record("Unexpected error in multiply: \(error)")
        }
        
        switch simd.scaleVector(a, by: 3.0) {
        case .success(let scaleResult):
            #expect(scaleResult.allSatisfy { $0 == 4.5 })
        case .failure(let error):
            Issue.record("Unexpected error in scale: \(error)")
        }
        
        switch simd.dotProduct(a, b) {
        case .success(let dotResult):
            #expect(dotResult == Double(size) * 1.5 * 2.5)
        case .failure(let error):
            Issue.record("Unexpected error in dot product: \(error)")
        }
        
        switch simd.sumVector(a) {
        case .success(let sumResult):
            #expect(sumResult == Double(size) * 1.5)
        case .failure(let error):
            Issue.record("Unexpected error in sum: \(error)")
        }
    }
}