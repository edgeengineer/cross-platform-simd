import Testing
import simd
@testable import CrossPlatformSIMD

struct SIMDOperationsIntegerTests {
    let simd = SIMDOperations()
    
    // MARK: - Int32 Array Tests
    
    @Test func testAddVectorsInt32() {
        let a: [Int32] = [1, 2, 3, 4, 5, 6, 7, 8]
        let b: [Int32] = [8, 7, 6, 5, 4, 3, 2, 1]
        let expected: [Int32] = [9, 9, 9, 9, 9, 9, 9, 9]
        
        switch simd.addVectors(a, b) {
        case .success(let result):
            #expect(result == expected)
        case .failure(let error):
            Issue.record("Unexpected error: \(error)")
        }
    }
    
    @Test func testMultiplyVectorsInt32() {
        let a: [Int32] = [2, 3, 4, 5]
        let b: [Int32] = [3, 4, 5, 6]
        let expected: [Int32] = [6, 12, 20, 30]
        
        switch simd.multiplyVectors(a, b) {
        case .success(let result):
            #expect(result == expected)
        case .failure(let error):
            Issue.record("Unexpected error: \(error)")
        }
    }
    
    @Test func testScaleVectorInt32() {
        let vector: [Int32] = [1, 2, 3, 4, 5]
        let scalar: Int32 = 3
        let expected: [Int32] = [3, 6, 9, 12, 15]
        
        switch simd.scaleVector(vector, by: scalar) {
        case .success(let result):
            #expect(result == expected)
        case .failure(let error):
            Issue.record("Unexpected error: \(error)")
        }
    }
    
    @Test func testSumVectorInt32() {
        let vector: [Int32] = [1, 2, 3, 4, 5, 6, 7, 8]
        let expected: Int32 = 36
        
        switch simd.sumVector(vector) {
        case .success(let result):
            #expect(result == expected)
        case .failure(let error):
            Issue.record("Unexpected error: \(error)")
        }
    }
    
    // MARK: - Int64 Array Tests
    
    @Test func testAddVectorsInt64() {
        let a: [Int64] = [1, 2, 3, 4, 5]
        let b: [Int64] = [5, 4, 3, 2, 1]
        let expected: [Int64] = [6, 6, 6, 6, 6]
        
        switch simd.addVectors(a, b) {
        case .success(let result):
            #expect(result == expected)
        case .failure(let error):
            Issue.record("Unexpected error: \(error)")
        }
    }
    
    @Test func testSumVectorInt64() {
        let vector: [Int64] = [10, 20, 30, 40, 50]
        let expected: Int64 = 150
        
        switch simd.sumVector(vector) {
        case .success(let result):
            #expect(result == expected)
        case .failure(let error):
            Issue.record("Unexpected error: \(error)")
        }
    }
    
    // MARK: - Direct SIMD Type Tests
    
    @Test func testSIMD4Int32Addition() {
        let a = SIMD4<Int32>(1, 2, 3, 4)
        let b = SIMD4<Int32>(5, 6, 7, 8)
        let expected = SIMD4<Int32>(6, 8, 10, 12)
        
        let result = simd.addVectors(a, b)
        
        #expect(result == expected)
    }
    
    @Test func testSIMD4Int32Multiplication() {
        let a = SIMD4<Int32>(2, 3, 4, 5)
        let b = SIMD4<Int32>(3, 4, 5, 6)
        let expected = SIMD4<Int32>(6, 12, 20, 30)
        
        let result = simd.multiplyVectors(a, b)
        
        #expect(result == expected)
    }
    
    @Test func testSIMD4Int32Scaling() {
        let vector = SIMD4<Int32>(1, 2, 3, 4)
        let scalar: Int32 = 5
        let expected = SIMD4<Int32>(5, 10, 15, 20)
        
        let result = simd.scaleVector(vector, by: scalar)
        
        #expect(result == expected)
    }
    
    @Test func testSIMD4Int32Sum() {
        let vector = SIMD4<Int32>(1, 2, 3, 4)
        let expected: Int32 = 10
        
        let result = simd.sumVector(vector)
        
        #expect(result == expected)
    }
    
    @Test func testSIMD2Int64Addition() {
        let a = SIMD2<Int64>(10, 20)
        let b = SIMD2<Int64>(30, 40)
        let expected = SIMD2<Int64>(40, 60)
        
        let result = simd.addVectors(a, b)
        
        #expect(result == expected)
    }
    
    @Test func testSIMD2Int64Sum() {
        let vector = SIMD2<Int64>(100, 200)
        let expected: Int64 = 300
        
        let result = simd.sumVector(vector)
        
        #expect(result == expected)
    }
    
    // MARK: - Bitwise Operations Tests
    
    @Test func testBitwiseAnd() {
        let a: [Int32] = [0b1111, 0b1010, 0b1100, 0b0011]
        let b: [Int32] = [0b1010, 0b1111, 0b0011, 0b1100]
        let expected: [Int32] = [0b1010, 0b1010, 0b0000, 0b0000]
        
        switch simd.bitwiseAnd(a, b) {
        case .success(let result):
            #expect(result == expected)
        case .failure(let error):
            Issue.record("Unexpected error: \(error)")
        }
    }
    
    @Test func testBitwiseOr() {
        let a: [Int32] = [0b1010, 0b0011, 0b1100, 0b0000]
        let b: [Int32] = [0b0101, 0b1100, 0b0011, 0b1111]
        let expected: [Int32] = [0b1111, 0b1111, 0b1111, 0b1111]
        
        switch simd.bitwiseOr(a, b) {
        case .success(let result):
            #expect(result == expected)
        case .failure(let error):
            Issue.record("Unexpected error: \(error)")
        }
    }
    
    @Test func testBitwiseXor() {
        let a: [Int32] = [0b1010, 0b1111, 0b1100, 0b0000]
        let b: [Int32] = [0b1111, 0b1010, 0b1100, 0b1111]
        let expected: [Int32] = [0b0101, 0b0101, 0b0000, 0b1111]
        
        switch simd.bitwiseXor(a, b) {
        case .success(let result):
            #expect(result == expected)
        case .failure(let error):
            Issue.record("Unexpected error: \(error)")
        }
    }
    
    // MARK: - Large Vector Tests
    
    @Test func testLargeInt32VectorOperations() {
        let size = 1000
        let a = [Int32](repeating: 2, count: size)
        let b = [Int32](repeating: 3, count: size)
        
        switch simd.addVectors(a, b) {
        case .success(let addResult):
            #expect(addResult.allSatisfy { $0 == 5 })
        case .failure(let error):
            Issue.record("Unexpected error in add: \(error)")
        }
        
        switch simd.multiplyVectors(a, b) {
        case .success(let multiplyResult):
            #expect(multiplyResult.allSatisfy { $0 == 6 })
        case .failure(let error):
            Issue.record("Unexpected error in multiply: \(error)")
        }
        
        switch simd.sumVector(a) {
        case .success(let sumResult):
            #expect(sumResult == Int32(size * 2))
        case .failure(let error):
            Issue.record("Unexpected error in sum: \(error)")
        }
    }
    
    // MARK: - Error Handling Tests
    
    @Test func testInt32MismatchedLengths() {
        let a: [Int32] = [1, 2, 3]
        let b: [Int32] = [4, 5]
        
        switch simd.addVectors(a, b) {
        case .success:
            Issue.record("Expected error but got success")
        case .failure(let error):
            if case .mismatchedVectorLengths(let lengthA, let lengthB) = error {
                #expect(lengthA == 3)
                #expect(lengthB == 2)
            } else {
                Issue.record("Wrong error type: \(error)")
            }
        }
    }
    
    @Test func testInt32EmptyInput() {
        let a: [Int32] = []
        let b: [Int32] = []
        
        switch simd.addVectors(a, b) {
        case .success:
            Issue.record("Expected error but got success")
        case .failure(let error):
            if case .emptyInput = error {
                // Expected error
            } else {
                Issue.record("Wrong error type: \(error)")
            }
        }
    }
}