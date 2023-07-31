import Foundation

public class CommunityRepositoryRemote: CommunityRepositoryType, NetworkType {
    var urlSession: URLSession
    var domain: URL
    var asyncActor: AsyncDataTaskActor
    
    init(domain: URL, urlSession: URLSession, keychain: KeychainType) {
        self.domain = domain
        self.urlSession = urlSession
        self.asyncActor = AsyncDataTaskActor(keychain: keychain)
    }
    
    public func getCommunities() async throws -> CommunityListResponse {
        return try await perform(http: CommunitySpec.communities)
    }
}
