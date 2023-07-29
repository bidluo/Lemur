import Foundation
import SwiftData

public protocol RepositoryProviderType {
    func inject() -> CommunityRepositoryType
    func inject() -> PostRepositoryType
    func inject() -> CommentRepositoryType
}

public class RepositoryProvider: RepositoryProviderType {
    private let domain: URL
    private let urlSession: URLSession
    
    private var postContext: ModelContext?
    
    public init() {
        domain = URL(string: "https://lemmy.world/api/v3/")!
        urlSession = URLSession.shared
        
        let container = try? ModelContainer(for: PostDetailResponseLocal.self)
        if let _container = container {
            postContext = ModelContext(_container)
            postContext?.autosaveEnabled = true
        }
    }
    
    public func inject() -> CommunityRepositoryType {
        let remote = CommunityRepositoryRemote(domain: domain, urlSession: urlSession)
        return CommunityRepositoryMain(remote: remote)
    }
    
    public func inject() -> PostRepositoryType {
        let remote = PostRepositoryRemote(domain: domain, urlSession: urlSession)
        let local = PostRepositoryLocal(context: postContext)
        return PostRepositoryMain(remote: remote, local: local)
    }
    
    public func inject() -> CommentRepositoryType {
        let remote = CommentRepositoryRemote(domain: domain, urlSession: urlSession)
        let local = CommentRepositoryLocal(context: postContext)
        return CommentRepositoryMain(remote: remote, local: local)
    }
}
