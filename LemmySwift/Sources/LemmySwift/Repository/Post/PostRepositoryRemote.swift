import Foundation

public class PostRepositoryRemote: NetworkType {
    var urlSession: URLSession
    var asyncActor: AsyncDataTaskActor
    
    init(urlSession: URLSession, keychain: KeychainType) {
        self.urlSession = urlSession
        self.asyncActor = AsyncDataTaskActor(keychain: keychain)
    }
    
    func getPosts(baseUrl: URL, sort: PostSort) async throws -> PostListResponse {
        return try await perform(baseUrl: baseUrl, http: PostSpec.posts(sort))
    }
    
    func getCommunityPosts(baseUrl: URL, communityId: Int, sort: PostSort) async throws -> PostListResponse {
        return try await perform(baseUrl: baseUrl, http: PostSpec.communityPosts(communityId, sort))
    }
    
    func getPost(baseUrl: URL, id: Int) async throws -> PostResponseRemote {
        return try await perform(baseUrl: baseUrl, http: PostSpec.post(id))
    }
}
