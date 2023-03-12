
import SwiftUI


@propertyWrapper
public struct Validated<Value>: Validatable, DynamicProperty {

    @State private var value: Value
    @State public private(set) var hasChanges = false
    @State public private(set) var isValid: Bool = true
    @State public private(set) var errMsg: String = ""
        
    public init(
        wrappedValue: Value,
        _ validation: Validation<Value>
    ) {
        self.validation = validation
        self._value = .init(
            initialValue: wrappedValue
        )

    }
    
    public var validation: Validation<Value> {
        didSet {
            self.reValidate(value: self.value)
        }
    }
    
    var isInvalid: Bool {
        !self.isValid
    }
    
    public var wrappedValue: Value {
        get {
            value
        }
        nonmutating set {
            value = newValue
        }
    }
    
    public var projectedValue: Binding<Value> {
        Binding(
             get: { wrappedValue },
             set: { wrappedValue = $0 }
         )
    }
    
    public func validate() {
        self.reValidate(value: self.value)
    }
    
    private func reValidate(value:Value){
        let result = self.validation.validate(value)
        switch result {
        case .success(_):
            self.isValid = true
            self.errMsg=""
        case .failure(let message):
            self.isValid = false
            self.errMsg=message.errorDescription ?? "Unknow Error"
        }
    }
}
