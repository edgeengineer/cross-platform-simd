import Testing
import CoreFoundation
@testable import CrossPlatformSIMD

struct SIMDOperationsPerformanceTests {
    let simd = SIMDOperations()
    
    // MARK: - Performance Comparison Tests
    
    @Test func performanceAddVectorsStandard() async {
        let size = 10000
        let a = [Float](repeating: 1.5, count: size)
        let b = [Float](repeating: 2.5, count: size)
        
        await confirmation("Standard add vectors performance") { confirm in
            let startTime = CFAbsoluteTimeGetCurrent()
            
            for _ in 0..<100 {
                _ = simd.addVectors(a, b)
            }
            
            let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
            print("Standard addVectors: \(timeElapsed)s for 100 iterations")
            confirm()
        }
    }
    
    @Test func performanceAddVectorsOptimized() async {
        let size = 10000
        let a = [Float](repeating: 1.5, count: size)
        let b = [Float](repeating: 2.5, count: size)
        
        await confirmation("Optimized add vectors performance") { confirm in
            let startTime = CFAbsoluteTimeGetCurrent()
            
            for _ in 0..<100 {
                _ = simd.addVectorsOptimized(a, b)
            }
            
            let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
            print("Optimized addVectors: \(timeElapsed)s for 100 iterations")
            confirm()
        }
    }
    
    @Test func performanceMultiplyVectorsStandard() async {
        let size = 10000
        let a = [Float](repeating: 1.5, count: size)
        let b = [Float](repeating: 2.5, count: size)
        
        await confirmation("Standard multiply vectors performance") { confirm in
            let startTime = CFAbsoluteTimeGetCurrent()
            
            for _ in 0..<100 {
                _ = simd.multiplyVectors(a, b)
            }
            
            let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
            print("Standard multiplyVectors: \(timeElapsed)s for 100 iterations")
            confirm()
        }
    }
    
    @Test func performanceMultiplyVectorsOptimized() async {
        let size = 10000
        let a = [Float](repeating: 1.5, count: size)
        let b = [Float](repeating: 2.5, count: size)
        
        await confirmation("Optimized multiply vectors performance") { confirm in
            let startTime = CFAbsoluteTimeGetCurrent()
            
            for _ in 0..<100 {
                _ = simd.multiplyVectorsOptimized(a, b)
            }
            
            let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
            print("Optimized multiplyVectors: \(timeElapsed)s for 100 iterations")
            confirm()
        }
    }
    
    @Test func performanceScaleVectorStandard() async {
        let size = 10000
        let vector = [Float](repeating: 1.5, count: size)
        let scalar: Float = 2.5
        
        await confirmation("Standard scale vector performance") { confirm in
            let startTime = CFAbsoluteTimeGetCurrent()
            
            for _ in 0..<100 {
                _ = simd.scaleVector(vector, by: scalar)
            }
            
            let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
            print("Standard scaleVector: \(timeElapsed)s for 100 iterations")
            confirm()
        }
    }
    
    @Test func performanceScaleVectorOptimized() async {
        let size = 10000
        let vector = [Float](repeating: 1.5, count: size)
        let scalar: Float = 2.5
        
        await confirmation("Optimized scale vector performance") { confirm in
            let startTime = CFAbsoluteTimeGetCurrent()
            
            for _ in 0..<100 {
                _ = simd.scaleVectorOptimized(vector, by: scalar)
            }
            
            let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
            print("Optimized scaleVector: \(timeElapsed)s for 100 iterations")
            confirm()
        }
    }
    
    @Test func performanceSumVectorStandard() async {
        let size = 100000
        let vector = [Float](repeating: 1.5, count: size)
        
        await confirmation("Standard sum vector performance") { confirm in
            let startTime = CFAbsoluteTimeGetCurrent()
            
            for _ in 0..<1000 {
                _ = simd.sumVector(vector)
            }
            
            let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
            print("Standard sumVector: \(timeElapsed)s for 1000 iterations")
            confirm()
        }
    }
    
    @Test func performanceSumVectorOptimized() async {
        let size = 100000
        let vector = [Float](repeating: 1.5, count: size)
        
        await confirmation("Optimized sum vector performance") { confirm in
            let startTime = CFAbsoluteTimeGetCurrent()
            
            for _ in 0..<1000 {
                _ = simd.sumVectorOptimized(vector)
            }
            
            let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
            print("Optimized sumVector: \(timeElapsed)s for 1000 iterations")
            confirm()
        }
    }
    
    // MARK: - SIMD Direct vs Array Performance
    
    @Test func performanceDirectSIMD4VsArray() async {
        let iterations = 1000000
        let a = SIMD4<Float>(1.0, 2.0, 3.0, 4.0)
        let b = SIMD4<Float>(5.0, 6.0, 7.0, 8.0)
        let arrayA: [Float] = [1.0, 2.0, 3.0, 4.0]
        let arrayB: [Float] = [5.0, 6.0, 7.0, 8.0]
        
        await confirmation("Direct SIMD4 vs Array performance") { confirm in
            // Direct SIMD4 performance
            let startTimeDirect = CFAbsoluteTimeGetCurrent()
            for _ in 0..<iterations {
                _ = simd.addVectors(a, b)
            }
            let directTime = CFAbsoluteTimeGetCurrent() - startTimeDirect
            print("Direct SIMD4: \(directTime)s for \(iterations) iterations")
            
            // Array-based performance
            let startTimeArray = CFAbsoluteTimeGetCurrent()
            for _ in 0..<iterations {
                _ = simd.addVectors(arrayA, arrayB)
            }
            let arrayTime = CFAbsoluteTimeGetCurrent() - startTimeArray
            print("Array-based: \(arrayTime)s for \(iterations) iterations")
            
            let speedup = arrayTime / directTime
            print("Direct SIMD4 is \(String(format: "%.2f", speedup))x faster")
            
            confirm()
        }
    }
    
    // MARK: - Naive vs SIMD Comparison
    
    @Test func performanceNaiveVsSIMD() async {
        let size = 10000
        let a = [Float](repeating: 1.5, count: size)
        let b = [Float](repeating: 2.5, count: size)
        
        await confirmation("Naive vs SIMD implementation comparison") { confirm in
            // Naive implementation
            let startTimeNaive = CFAbsoluteTimeGetCurrent()
            for _ in 0..<100 {
                var result = [Float](repeating: 0, count: size)
                for i in 0..<size {
                    result[i] = a[i] + b[i]
                }
            }
            let naiveTime = CFAbsoluteTimeGetCurrent() - startTimeNaive
            print("Naive implementation: \(naiveTime)s for 100 iterations")
            
            // SIMD implementation
            let startTimeSIMD = CFAbsoluteTimeGetCurrent()
            for _ in 0..<100 {
                _ = simd.addVectors(a, b)
            }
            let simdTime = CFAbsoluteTimeGetCurrent() - startTimeSIMD
            print("SIMD implementation: \(simdTime)s for 100 iterations")
            
            let speedup = naiveTime / simdTime
            print("SIMD is \(String(format: "%.2f", speedup))x faster than naive")
            
            confirm()
        }
    }
    
    // MARK: - Matrix Multiplication Performance
    
    @Test func performanceMatrixMultiplication() async {
        let size = 100
        let matrixA = [[Float]](repeating: [Float](repeating: 1.5, count: size), count: size)
        let matrixB = [[Float]](repeating: [Float](repeating: 2.5, count: size), count: size)
        
        await confirmation("Matrix multiplication performance") { confirm in
            let startTime = CFAbsoluteTimeGetCurrent()
            
            for _ in 0..<10 {
                _ = simd.matrixMultiply(matrixA, matrixB)
            }
            
            let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
            print("Matrix multiplication (\(size)x\(size)): \(timeElapsed)s for 10 iterations")
            confirm()
        }
    }
    
    // MARK: - Correctness Verification for Optimized Functions
    
    @Test func verifyOptimizedCorrectness() {
        let size = 1000
        let a = (0..<size).map { Float($0) }
        let b = (0..<size).map { Float($0 * 2) }
        let scalar: Float = 3.14
        
        // Verify addVectors
        switch (simd.addVectors(a, b), simd.addVectorsOptimized(a, b)) {
        case (.success(let standard), .success(let optimized)):
            #expect(standard == optimized, "Optimized addVectors should match standard implementation")
        default:
            Issue.record("Failed to get results from addVectors implementations")
        }
        
        // Verify multiplyVectors
        switch (simd.multiplyVectors(a, b), simd.multiplyVectorsOptimized(a, b)) {
        case (.success(let standard), .success(let optimized)):
            #expect(standard == optimized, "Optimized multiplyVectors should match standard implementation")
        default:
            Issue.record("Failed to get results from multiplyVectors implementations")
        }
        
        // Verify scaleVector
        switch (simd.scaleVector(a, by: scalar), simd.scaleVectorOptimized(a, by: scalar)) {
        case (.success(let standard), .success(let optimized)):
            #expect(standard == optimized, "Optimized scaleVector should match standard implementation")
        default:
            Issue.record("Failed to get results from scaleVector implementations")
        }
        
        // Verify sumVector
        switch (simd.sumVector(a), simd.sumVectorOptimized(a)) {
        case (.success(let standard), .success(let optimized)):
            #expect(abs(standard - optimized) < Float(0.001), "Optimized sumVector should match standard implementation")
        default:
            Issue.record("Failed to get results from sumVector implementations")
        }
    }
}