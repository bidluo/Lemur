import Foundation

public class PostRepositoryRemote: NetworkType {
    var urlSession: URLSession
    var asyncActor: AsyncDataTaskActor
    
    init(urlSession: URLSession, keychain: KeychainType) {
        self.urlSession = urlSession
        self.asyncActor = AsyncDataTaskActor(keychain: keychain)
    }
    
    func getPosts(baseUrl: URL, request: GetPostRequest) async throws -> PostListResponse {
        return try await perform(baseUrl: baseUrl, http: PostSpec.posts(request))
    }
    
    func getCommunityPosts(baseUrl: URL, communityId: Int, request: GetPostRequest) async throws -> PostListResponse {
        return try await perform(baseUrl: baseUrl, http: PostSpec.communityPosts(communityId, request))
    }
    
    func getPost(baseUrl: URL, id: Int) async throws -> PostResponseRemote {
        return try await perform(baseUrl: baseUrl, http: PostSpec.post(id))
    }
    
    func votePost(siteURL: URL, request: PostVoteRequest) async throws -> PostResponseRemote {
        return try await perform(baseUrl: siteURL, http: PostSpec.vote(request))
    }
}
