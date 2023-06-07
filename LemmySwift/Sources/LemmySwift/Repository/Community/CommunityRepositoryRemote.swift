import Foundation

public class CommunityRepositoryRemote: CommunityRepositoryType, NetworkType {
    var urlSession: URLSession
    var domain: URL
    var asyncActor: AsyncDataTaskActor
    
    init(domain: URL, urlSession: URLSession) {
        self.domain = domain
        self.urlSession = urlSession
        self.asyncActor = AsyncDataTaskActor()
    }
    
    public func getCommunities() async throws -> CommunityListResponse {
        return try await perform(http: CommunitySpec.communities)
    }
}
