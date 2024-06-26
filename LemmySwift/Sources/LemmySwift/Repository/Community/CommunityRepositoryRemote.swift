import Foundation

class CommunityRepositoryRemote: NetworkType {
    var urlSession: URLSession
    var asyncActor: AsyncDataTaskActor
    
    init(urlSession: URLSession, keychain: KeychainType) {
        self.urlSession = urlSession
        self.asyncActor = AsyncDataTaskActor(keychain: keychain)
    }
    
    func getCommunities(baseUrl: URL, sort: PostSort) async throws -> CommunityListResponse {
        return try await perform(baseUrl: baseUrl, http: CommunitySpec.communities(sort))
    }
    
    func getSubscribedCommunities(baseUrl: URL) async throws -> CommunityListResponse {
        return try await perform(baseUrl: baseUrl, http: CommunitySpec.subscribedCommunities)
    }
}
