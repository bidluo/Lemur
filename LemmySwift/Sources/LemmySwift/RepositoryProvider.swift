import Foundation
import SwiftData

public protocol RepositoryProviderType {
    func inject() -> AuthenticationRepositoryType
    func inject() -> CommentRepositoryType
    func inject() -> CommunityRepositoryType
    func inject() -> PostRepositoryType
    func inject() -> SiteRepositoryType
    func inject() -> UserRepositoryType
}

public class RepositoryProvider: RepositoryProviderType {
    private let urlSession: URLSession
    
    private var container: ModelContainer
    private let keychain: KeychainType
    private let siteRepository: SiteRepositoryType
    
    public init(keychain: KeychainType) {
        self.urlSession = URLSession.shared
        self.keychain = keychain
        
        // TODO: Handle migrations
        container = try! ModelContainer(for: PostDetail.self, Community.self)
        
        let siteRemote = SiteRepositoryRemote(urlSession: urlSession, keychain: keychain)
        let siteLocal = SiteRepositoryLocal(container: container)
        siteRepository = SiteRepository(remote: siteRemote, local: siteLocal)
    }
    
    public func inject() -> AuthenticationRepositoryType {
        let remote = AuthenticationRepositoryRemote(urlSession: urlSession, keychain: keychain)
        return AuthenticationRepositoryMain(remote: remote)
    }
    
    public func inject() -> CommentRepositoryType {
        let remote = CommentRepositoryRemote(urlSession: urlSession, keychain: keychain)
        let local = CommentRepositoryLocal(container: container)
        return CommentRepositoryMain(remote: remote, local: local)
    }
    
    public func inject() -> CommunityRepositoryType {
        let remote = CommunityRepositoryRemote(urlSession: urlSession, keychain: keychain)
        let local = CommunityRepositoryLocal(container: container)
        return CommunityRepositoryMain(remote: remote, local: local, siteRepository: inject())
    }
    
    public func inject() -> PostRepositoryType {
        let remote = PostRepositoryRemote(urlSession: urlSession, keychain: keychain)
        let local = PostRepositoryLocal(container: container)
        return PostRepositoryMain(remote: remote, local: local, siteRepository: inject())
    }
    
    public func inject() -> SiteRepositoryType {
        return siteRepository
    }
    
    public func inject() -> UserRepositoryType {
        let remote = UserRepositoryRemote(urlSession: urlSession, keychain: keychain)
        let local = UserRepositoryLocal(container: container)
        return UserRepository(remote: remote, local: local)
    }
}
