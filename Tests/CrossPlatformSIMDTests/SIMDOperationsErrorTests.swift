import Testing
@testable import CrossPlatformSIMD

struct SIMDOperationsErrorTests {
    let simd = SIMDOperations()
    
    // MARK: - Mismatched Vector Lengths
    
    @Test func testAddVectorsMismatchedLengths() {
        let a: [Float] = [1.0, 2.0, 3.0]
        let b: [Float] = [4.0, 5.0]
        
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
    
    @Test func testDotProductMismatchedLengths() {
        let a: [Double] = [1.0, 2.0, 3.0, 4.0]
        let b: [Double] = [5.0, 6.0]
        
        switch simd.dotProduct(a, b) {
        case .success:
            Issue.record("Expected error but got success")
        case .failure(let error):
            if case .mismatchedVectorLengths = error {
                // Expected error
            } else {
                Issue.record("Wrong error type: \(error)")
            }
        }
    }
    
    @Test func testMultiplyVectorsMismatchedLengths() {
        let a: [Float] = [1.0, 2.0]
        let b: [Float] = [3.0, 4.0, 5.0]
        
        switch simd.multiplyVectors(a, b) {
        case .success:
            Issue.record("Expected error but got success")
        case .failure(let error):
            if case .mismatchedVectorLengths = error {
                // Expected error
            } else {
                Issue.record("Wrong error type: \(error)")
            }
        }
    }
    
    // MARK: - Empty Input
    
    @Test func testAddVectorsEmptyInput() {
        let a: [Float] = []
        let b: [Float] = []
        
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
    
    @Test func testDotProductEmptyInput() {
        let a: [Double] = []
        let b: [Double] = []
        
        switch simd.dotProduct(a, b) {
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
    
    @Test func testScaleVectorEmptyInput() {
        let vector: [Float] = []
        
        switch simd.scaleVector(vector, by: 2.0) {
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
    
    @Test func testSumVectorEmptyInput() {
        let vector: [Double] = []
        
        switch simd.sumVector(vector) {
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
    
    // MARK: - Matrix Operations
    
    @Test func testMatrixMultiplyEmptyInput() {
        let a: [[Float]] = []
        let b: [[Float]] = [[1.0, 2.0], [3.0, 4.0]]
        
        switch simd.matrixMultiply(a, b) {
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
    
    @Test func testMatrixMultiplyInvalidDimensions() {
        let a: [[Float]] = [[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]]
        let b: [[Float]] = [[7.0, 8.0], [9.0, 10.0]]
        
        switch simd.matrixMultiply(a, b) {
        case .success:
            Issue.record("Expected error but got success")
        case .failure(let error):
            if case .invalidMatrixDimensions = error {
                // Expected error
            } else {
                Issue.record("Wrong error type: \(error)")
            }
        }
    }
    
    @Test func testMatrixMultiplyEmptyRow() {
        let a: [[Double]] = [[]]
        let b: [[Double]] = [[1.0]]
        
        switch simd.matrixMultiply(a, b) {
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
    
    // MARK: - Error Messages
    
    @Test func testErrorMessages() {
        let error1 = SIMDError.mismatchedVectorLengths(lengthA: 5, lengthB: 3)
        #expect(error1.localizedDescription == "Vector lengths do not match: 5 != 3")
        
        let error2 = SIMDError.invalidMatrixDimensions(message: "Test message")
        #expect(error2.localizedDescription == "Invalid matrix dimensions: Test message")
        
        let error3 = SIMDError.unsupportedType("CustomType")
        #expect(error3.localizedDescription == "Unsupported type for SIMD operations: CustomType")
        
        let error4 = SIMDError.emptyInput
        #expect(error4.localizedDescription == "Empty input provided where non-empty input is required")
    }
}