import Foundation
import Factory
import LemmySwift
import SwiftUI

extension Container {
    var repositoryProvider: Factory<RepositoryProviderType> {
        Factory(self) { RepositoryProvider(keychain: Keychain()) }.singleton
    }
}

public extension Container {
    var keychain: Factory<KeychainType> {
        Factory(self) { Keychain() }.singleton
    }
}

public extension Container {
    var postRepository: Factory<PostRepositoryType> {
        Factory(self) { self.repositoryProvider().inject() }
    }
    
    var authenticationRepository: Factory<AuthenticationRepositoryType> {
        Factory(self) { self.repositoryProvider().inject() }
    }
    
    var commentRepository: Factory<CommentRepositoryType> {
        Factory(self) { self.repositoryProvider().inject() }
    }
    
    var communityRepository: Factory<CommunityRepositoryType> {
        Factory(self) { self.repositoryProvider().inject() }
    }
}

@propertyWrapper public struct UseCase<T: UseCaseType> {
    private var factory: Factory<T>
    private var dependency: T
    public init() {
        let factory = Factory(Container.shared) {
            return T()
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

@propertyWrapper public struct UseCaseStream<T: UseCaseStreamType> {
    private var factory: Factory<T>
    private var dependency: T
    public init() {
        let factory = Factory(Container.shared) {
            return T()
        }
        
        self.factory = factory
        self.dependency = factory()
    }
    
    public var wrappedValue: T {
        get { return dependency }
        mutating set { dependency = newValue }
    }
    
    public var projectedValue: UseCaseStream<T> {
        get { return self }
        mutating set { self = newValue }
    }
    
    public mutating func resolve(reset options: FactoryResetOptions = .none) {
        factory.reset(options)
        dependency = factory()
    }
}
