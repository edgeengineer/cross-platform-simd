import Foundation
import simd

public struct SIMDOperations {
    
    public init() {}
    
    public func addVectors<T: SIMDScalar>(_ a: [T], _ b: [T]) -> [T] where T.SIMDMaskScalar: SIMDScalar {
        guard a.count == b.count else {
            fatalError("Vectors must have the same length")
        }
        
        let simdWidth = 4
        let simdCount = a.count / simdWidth
        
        if T.self == Float.self {
            let aFloat = a as! [Float]
            let bFloat = b as! [Float]
            var resultFloat = [Float](repeating: 0, count: a.count)
            
            for i in 0..<simdCount {
                let offset = i * simdWidth
                let va = SIMD4<Float>(aFloat[offset..<offset+simdWidth])
                let vb = SIMD4<Float>(bFloat[offset..<offset+simdWidth])
                let vr = va + vb
                for j in 0..<simdWidth {
                    resultFloat[offset + j] = vr[j]
                }
            }
            
            for i in (simdCount * simdWidth)..<a.count {
                resultFloat[i] = aFloat[i] + bFloat[i]
            }
            
            return resultFloat as! [T]
        } else if T.self == Double.self {
            let aDouble = a as! [Double]
            let bDouble = b as! [Double]
            var resultDouble = [Double](repeating: 0, count: a.count)
            
            for i in 0..<simdCount {
                let offset = i * simdWidth
                let va = SIMD4<Double>(aDouble[offset..<offset+simdWidth])
                let vb = SIMD4<Double>(bDouble[offset..<offset+simdWidth])
                let vr = va + vb
                for j in 0..<simdWidth {
                    resultDouble[offset + j] = vr[j]
                }
            }
            
            for i in (simdCount * simdWidth)..<a.count {
                resultDouble[i] = aDouble[i] + bDouble[i]
            }
            
            return resultDouble as! [T]
        }
        
        fatalError("Unsupported type")
    }
    
    public func dotProduct<T: SIMDScalar>(_ a: [T], _ b: [T]) -> T where T.SIMDMaskScalar: SIMDScalar, T: Numeric {
        guard a.count == b.count else {
            fatalError("Vectors must have the same length")
        }
        
        let simdWidth = 4
        let simdCount = a.count / simdWidth
        
        if T.self == Float.self {
            let aFloat = a as! [Float]
            let bFloat = b as! [Float]
            var sumFloat: Float = 0
            
            for i in 0..<simdCount {
                let offset = i * simdWidth
                let va = SIMD4<Float>(aFloat[offset..<offset+simdWidth])
                let vb = SIMD4<Float>(bFloat[offset..<offset+simdWidth])
                let product = va * vb
                sumFloat += product.sum()
            }
            
            for i in (simdCount * simdWidth)..<a.count {
                sumFloat += aFloat[i] * bFloat[i]
            }
            
            return sumFloat as! T
        } else if T.self == Double.self {
            let aDouble = a as! [Double]
            let bDouble = b as! [Double]
            var sumDouble: Double = 0
            
            for i in 0..<simdCount {
                let offset = i * simdWidth
                let va = SIMD4<Double>(aDouble[offset..<offset+simdWidth])
                let vb = SIMD4<Double>(bDouble[offset..<offset+simdWidth])
                let product = va * vb
                sumDouble += product.sum()
            }
            
            for i in (simdCount * simdWidth)..<a.count {
                sumDouble += aDouble[i] * bDouble[i]
            }
            
            return sumDouble as! T
        }
        
        fatalError("Unsupported type")
    }
    
    public func multiplyVectors<T: SIMDScalar>(_ a: [T], _ b: [T]) -> [T] where T.SIMDMaskScalar: SIMDScalar {
        guard a.count == b.count else {
            fatalError("Vectors must have the same length")
        }
        
        let simdWidth = 4
        let simdCount = a.count / simdWidth
        
        if T.self == Float.self {
            let aFloat = a as! [Float]
            let bFloat = b as! [Float]
            var resultFloat = [Float](repeating: 0, count: a.count)
            
            for i in 0..<simdCount {
                let offset = i * simdWidth
                let va = SIMD4<Float>(aFloat[offset..<offset+simdWidth])
                let vb = SIMD4<Float>(bFloat[offset..<offset+simdWidth])
                let vr = va * vb
                for j in 0..<simdWidth {
                    resultFloat[offset + j] = vr[j]
                }
            }
            
            for i in (simdCount * simdWidth)..<a.count {
                resultFloat[i] = aFloat[i] * bFloat[i]
            }
            
            return resultFloat as! [T]
        } else if T.self == Double.self {
            let aDouble = a as! [Double]
            let bDouble = b as! [Double]
            var resultDouble = [Double](repeating: 0, count: a.count)
            
            for i in 0..<simdCount {
                let offset = i * simdWidth
                let va = SIMD4<Double>(aDouble[offset..<offset+simdWidth])
                let vb = SIMD4<Double>(bDouble[offset..<offset+simdWidth])
                let vr = va * vb
                for j in 0..<simdWidth {
                    resultDouble[offset + j] = vr[j]
                }
            }
            
            for i in (simdCount * simdWidth)..<a.count {
                resultDouble[i] = aDouble[i] * bDouble[i]
            }
            
            return resultDouble as! [T]
        }
        
        fatalError("Unsupported type")
    }
    
    public func scaleVector<T: SIMDScalar>(_ vector: [T], by scalar: T) -> [T] where T.SIMDMaskScalar: SIMDScalar {
        let simdWidth = 4
        let simdCount = vector.count / simdWidth
        
        if T.self == Float.self {
            let vectorFloat = vector as! [Float]
            let scalarFloat = scalar as! Float
            var resultFloat = [Float](repeating: 0, count: vector.count)
            
            for i in 0..<simdCount {
                let offset = i * simdWidth
                let v = SIMD4<Float>(vectorFloat[offset..<offset+simdWidth])
                let scaled = v * scalarFloat
                for j in 0..<simdWidth {
                    resultFloat[offset + j] = scaled[j]
                }
            }
            
            for i in (simdCount * simdWidth)..<vector.count {
                resultFloat[i] = vectorFloat[i] * scalarFloat
            }
            
            return resultFloat as! [T]
        } else if T.self == Double.self {
            let vectorDouble = vector as! [Double]
            let scalarDouble = scalar as! Double
            var resultDouble = [Double](repeating: 0, count: vector.count)
            
            for i in 0..<simdCount {
                let offset = i * simdWidth
                let v = SIMD4<Double>(vectorDouble[offset..<offset+simdWidth])
                let scaled = v * scalarDouble
                for j in 0..<simdWidth {
                    resultDouble[offset + j] = scaled[j]
                }
            }
            
            for i in (simdCount * simdWidth)..<vector.count {
                resultDouble[i] = vectorDouble[i] * scalarDouble
            }
            
            return resultDouble as! [T]
        }
        
        fatalError("Unsupported type")
    }
    
    public func sumVector<T: SIMDScalar>(_ vector: [T]) -> T where T.SIMDMaskScalar: SIMDScalar, T: Numeric {
        let simdWidth = 4
        let simdCount = vector.count / simdWidth
        
        if T.self == Float.self {
            let vectorFloat = vector as! [Float]
            var sumFloat: Float = 0
            
            for i in 0..<simdCount {
                let offset = i * simdWidth
                let v = SIMD4<Float>(vectorFloat[offset..<offset+simdWidth])
                sumFloat += v.sum()
            }
            
            for i in (simdCount * simdWidth)..<vector.count {
                sumFloat += vectorFloat[i]
            }
            
            return sumFloat as! T
        } else if T.self == Double.self {
            let vectorDouble = vector as! [Double]
            var sumDouble: Double = 0
            
            for i in 0..<simdCount {
                let offset = i * simdWidth
                let v = SIMD4<Double>(vectorDouble[offset..<offset+simdWidth])
                sumDouble += v.sum()
            }
            
            for i in (simdCount * simdWidth)..<vector.count {
                sumDouble += vectorDouble[i]
            }
            
            return sumDouble as! T
        }
        
        fatalError("Unsupported type")
    }
    
    public func matrixMultiply(_ a: [[Float]], _ b: [[Float]]) -> [[Float]] {
        let m = a.count
        let n = b[0].count
        let p = b.count
        
        guard a[0].count == p else {
            fatalError("Invalid matrix dimensions for multiplication")
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
        
        return result
    }
}

extension SIMD4 where Scalar: Numeric {
    func sum() -> Scalar {
        return self[0] + self[1] + self[2] + self[3]
    }
}