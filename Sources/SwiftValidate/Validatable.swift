public protocol Validatable {
    var isValid: Bool { get }
    func validate()
}
