import Foundation

public class PostRepositoryRemote: PostRepositoryType, NetworkType {
    var urlSession: URLSession
    var domain: URL
    var asyncActor: AsyncDataTaskActor
    
    init(domain: URL, urlSession: URLSession) {
        self.domain = domain
        self.urlSession = urlSession
        self.asyncActor = AsyncDataTaskActor()
    }
    
    public func getPosts() async throws -> PostListResponse {
        return try await perform(http: PostSpec.posts)
    }
    
    public func getPost(id: Int) async throws -> PostResponse {
        return try await perform(http: PostSpec.post(id))
    }
}
