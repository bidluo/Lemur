import Foundation
import SwiftData

public protocol RepositoryProviderType {
    func inject() -> CommunityRepositoryType
    func inject() -> any PostRepositoryType
}

public class RepositoryProvider: RepositoryProviderType {
    private let domain: URL
    private let urlSession: URLSession
    
    lazy var container: ModelContainer? = {
        let container = try? ModelContainer(for: PostDetailResponseLocal.self)
        return container
    }()
    
    private var postContext: ModelContext?
    
    public init() {
        domain = URL(string: "https://lemmy.world/api/v3/")!
        urlSession = URLSession.shared
        
        if let container = self.container {
            postContext = ModelContext(container)
        }
    }
    
    public func inject() -> CommunityRepositoryType {
        let remote = CommunityRepositoryRemote(domain: domain, urlSession: urlSession)
        return CommunityRepositoryMain(remote: remote)
    }
    
    public func inject() -> any PostRepositoryType {
        let remote = PostRepositoryRemote(domain: domain, urlSession: urlSession)
        let local = PostRepositoryLocal(context: postContext)
        return PostRepositoryMain(remote: remote, local: local)
    }
}
