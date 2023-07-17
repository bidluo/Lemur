import Foundation
import LemmySwift
import Factory

public protocol UseCaseType {
    associatedtype Input
    associatedtype Result
    
    init()
    
    func call(input: Input) async throws -> Result
}

extension UseCaseType where Input == Void {
    @discardableResult
    public func call() async throws -> Result {
        try await self.call(input: ())
    }
}

extension UseCaseType where Result == Void {
    @discardableResult
    public func call(input: Input) async throws -> Result {
        try await self.call(input: input)
    }
}

public protocol UseCaseFactoryType {
    func create<T: UseCaseType>() -> T
}

public class UseCaseFactory: UseCaseFactoryType {
    
    init() {
    }
    
    public func create<T: UseCaseType>() -> T {
        return T()
    }
}

@propertyWrapper public struct UseCase<T: UseCaseType> {
    private var factory: Factory<T>
    private var dependency: T
    public init() {
        let useCaseFactory = Container.shared.useCaseFactory()
        let factory = Factory(Container.shared) {
            let useCase: T = useCaseFactory.create()
            return useCase
        }
        
        self.factory = factory
        self.dependency = factory()
    }
    
    public var wrappedValue: T {
        get { return dependency }
        mutating set { dependency = newValue }
    }
    
    public var projectedValue: UseCase<T> {
        get { return self }
        mutating set { self = newValue }
    }
    
    public mutating func resolve(reset options: FactoryResetOptions = .none) {
        factory.reset(options)
        dependency = factory()
    }
}
