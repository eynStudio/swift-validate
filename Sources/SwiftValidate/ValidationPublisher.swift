
import Combine

public typealias ValidationPublisher = AnyPublisher<Validated<Void>, Never>

public typealias ValidationPublisherOf<T> = AnyPublisher<Validated<T>, Never>
