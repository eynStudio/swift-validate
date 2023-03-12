
import Foundation

public enum ValidationError: LocalizedError {
    case missingName

    public var errorDescription: String? {
        switch self {
        case .missingName:
            return "Name is a required field."
        }
    }
}

public struct Validation<Value> {
    
    public typealias ValidationResult = Result<Value, ValidationError>
    public typealias Predicate = (Value) -> ValidationResult
    private let predicate: Predicate

    func validate(
        _ value: Value
    ) -> ValidationResult {
        self.predicate(value)
    }
    
    static prefix func ! (
        validation: Self
    ) -> Self {
        .init { value in
            validation.validate(value)
        }
    }
    
}


public extension Validation where Value: Collection {
    
    static var isEmpty: Self {
        .init { value in
            if  value.isEmpty {
                return .success(value)
            }else{
                return .failure(ValidationError.missingName)
            }
        }
    }
    
 
    
}
