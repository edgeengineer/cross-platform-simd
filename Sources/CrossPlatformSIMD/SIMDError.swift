#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

/// Errors that can occur during SIMD operations
public enum SIMDError: Error, LocalizedError {
    /// Vectors have mismatched lengths
    case mismatchedVectorLengths(lengthA: Int, lengthB: Int)
    
    /// Matrix dimensions are invalid for the requested operation
    case invalidMatrixDimensions(message: String)
    
    /// The provided type is not supported for SIMD operations
    case unsupportedType(String)
    
    /// Input is empty when non-empty input is required
    case emptyInput
    
    public var errorDescription: String? {
        switch self {
        case .mismatchedVectorLengths(let lengthA, let lengthB):
            return "Vector lengths do not match: \(lengthA) != \(lengthB)"
        case .invalidMatrixDimensions(let message):
            return "Invalid matrix dimensions: \(message)"
        case .unsupportedType(let type):
            return "Unsupported type for SIMD operations: \(type)"
        case .emptyInput:
            return "Empty input provided where non-empty input is required"
        }
    }
}