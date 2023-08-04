import Foundation

class CommunityRepositoryRemote: NetworkType {
    var urlSession: URLSession
    var domain: URL
    var asyncActor: AsyncDataTaskActor
    
    init(domain: URL, urlSession: URLSession, keychain: KeychainType) {
        self.domain = domain
        self.urlSession = urlSession
        self.asyncActor = AsyncDataTaskActor(keychain: keychain)
    }
    
    func getCommunities() async throws -> CommunityListResponse {
        return try await perform(http: CommunitySpec.communities)
    }
}
