import simd

// MARK: - SIMD Extensions

internal extension SIMD4 where Scalar: Numeric {
    /// Returns the sum of all elements in the SIMD4 vector
    func sum() -> Scalar {
        return self[0] + self[1] + self[2] + self[3]
    }
}

internal extension SIMD8 where Scalar: Numeric {
    /// Returns the sum of all elements in the SIMD8 vector
    func sum() -> Scalar {
        return self[0] + self[1] + self[2] + self[3] + self[4] + self[5] + self[6] + self[7]
    }
}

internal extension SIMD16 where Scalar: Numeric {
    /// Returns the sum of all elements in the SIMD16 vector
    func sum() -> Scalar {
        return self[0] + self[1] + self[2] + self[3] + self[4] + self[5] + self[6] + self[7] +
               self[8] + self[9] + self[10] + self[11] + self[12] + self[13] + self[14] + self[15]
    }
}