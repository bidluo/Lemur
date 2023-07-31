import Foundation
import SwiftData

public protocol RepositoryProviderType {
    func inject() -> CommunityRepositoryType
    func inject() -> PostRepositoryType
    func inject() -> CommentRepositoryType
    func inject() -> AuthenticationRepositoryType
}

public class RepositoryProvider: RepositoryProviderType {
    private let domain: URL
    private let urlSession: URLSession
    
    private var postContext: ModelContext?
    private let keychain: KeychainType
    
    public init(keychain: KeychainType) {
        self.domain = URL(string: "http://localhost:8536/api/v3/")!
        self.urlSession = URLSession.shared
        self.keychain = keychain
        
        let container = try? ModelContainer(for: PostDetailResponseLocal.self)
        if let _container = container {
            postContext = ModelContext(_container)
            postContext?.autosaveEnabled = true
        }
    }
    
    public func inject() -> CommunityRepositoryType {
        let remote = CommunityRepositoryRemote(domain: domain, urlSession: urlSession, keychain: keychain)
        return CommunityRepositoryMain(remote: remote)
    }
    
    public func inject() -> PostRepositoryType {
        let remote = PostRepositoryRemote(domain: domain, urlSession: urlSession, keychain: keychain)
        let local = PostRepositoryLocal(context: postContext)
        return PostRepositoryMain(remote: remote, local: local)
    }
    
    public func inject() -> CommentRepositoryType {
        let remote = CommentRepositoryRemote(domain: domain, urlSession: urlSession, keychain: keychain)
        let local = CommentRepositoryLocal(context: postContext)
        return CommentRepositoryMain(remote: remote, local: local)
    }
    
    public func inject() -> AuthenticationRepositoryType {
        let remote = AuthenticationRepositoryRemote(domain: domain, urlSession: urlSession, keychain: keychain)
        return AuthenticationRepositoryMain(remote: remote)
    }
}
