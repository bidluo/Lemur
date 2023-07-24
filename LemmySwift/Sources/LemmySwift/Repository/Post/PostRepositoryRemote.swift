import Foundation

public class PostRepositoryRemote: NetworkType {
    var urlSession: URLSession
    var domain: URL
    var asyncActor: AsyncDataTaskActor
    
    init(domain: URL, urlSession: URLSession) {
        self.domain = domain
        self.urlSession = urlSession
        self.asyncActor = AsyncDataTaskActor()
    }
    
    public func getPosts() async throws -> PostListRemote {
        return try await perform(http: PostSpec.posts, for: PostListRemote.self)
    }
    
    public func getPost(id: Int) async throws -> PostResponse {
        return try await perform(http: PostSpec.post(id), for: PostResponseRemote.self)
    }
    
    public func getPostComments(postId: Int) async throws -> CommentListResponse {
        return try await perform(http: PostSpec.postComments(postId))
    }
}
