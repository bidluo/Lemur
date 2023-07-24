import Foundation
import SwiftData

public protocol RepositoryProviderType {
    func inject() -> CommunityRepositoryType
    func inject() -> any PostRepositoryType
}

public class RepositoryProvider: RepositoryProviderType {
    private let domain: URL
    private let urlSession: URLSession
    
    lazy var container: ModelContainer = {
        let container = try! ModelContainer(for: PostDetailResponseLocal.self)
        return container
    }()
    
    public init() {
        domain = URL(string: "https://lemmy.world/api/v3/")!
        urlSession = URLSession.shared
    }
    
    public func inject() -> CommunityRepositoryType {
        let remote = CommunityRepositoryRemote(domain: domain, urlSession: urlSession)
        return CommunityRepositoryMain(remote: remote)
    }
    
    public func inject() -> any PostRepositoryType {
        let remote = PostRepositoryRemote(domain: domain, urlSession: urlSession)
        let local = PostRepositoryLocal(container: container)
        return PostRepositoryMain(remote: remote, local: local)
    }
}
