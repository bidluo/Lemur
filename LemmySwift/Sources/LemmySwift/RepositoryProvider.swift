import Foundation

public protocol RepositoryProviderType {
    func inject() -> CommunityRepositoryType
}

public class RepositoryProvider: RepositoryProviderType {
    private let domain: URL
    private let urlSession: URLSession
    
    public init() {
        domain = URL(string: "https://lemmy.ml/api/v3/")!
        urlSession = URLSession.shared
    }
    
    public func inject() -> CommunityRepositoryType {
        let remote = CommunityRepositoryRemote(domain: domain, urlSession: urlSession)
        return CommunityRepositoryMain(remote: remote)
    }
}
