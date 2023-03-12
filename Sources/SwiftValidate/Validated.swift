
import Foundation

public enum Validated<Payload> : Equatable {
    case untouched
    case success(Payload?)
    case failure(reason: String)
    
    public var isUntouched: Bool {
        guard case .untouched = self else { return false }
        return true
    }
    
    public var isSuccess: Bool {
        guard case .success = self else { return false }
        return true
    }
    
    public static func == (lhs: Validated<Payload>, rhs: Validated<Payload>) -> Bool {
        switch (lhs, rhs) {
        case (.untouched, .untouched): return true
        case (.success, .success): return true
        case (.failure(let reasonLhs), .failure(let reasonRhs)):
            guard reasonLhs == reasonRhs else { return false }
            return true
        default: return false
        }
    }
}
