import Foundation
import Combine

public func NotEmptyValidator(
    for publisher: AnyPublisher<String, Never>,
    error message: String
) -> ValidationPublisher {
    publisher
        .dropFirst()
        .debounce(for: .seconds(0.25), scheduler: RunLoop.main)
        .map(\.isEmpty)
        .map { !$0 ? .success(.none) : .failure(reason: message) }
        .eraseToAnyPublisher()
}

extension Publisher where Output == String, Failure == Never {
    public func validateNonEmpty(
        error message: String
    ) -> ValidationPublisher {
        NotEmptyValidator(for: AnyPublisher(self), error: message)
    }
    
}
 
