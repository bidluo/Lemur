import Foundation

public protocol PostRepositoryType {
    func getPosts() async throws -> PostListResponse
    func getPost(id: Int) async throws -> PostResponse
    func getPostComments(postId: Int) async throws -> CommentListResponse
}

public class PostRepositoryMain: PostRepositoryType {
    
    private let remote: PostRepositoryRemote
    
    init(remote: PostRepositoryRemote) {
        self.remote = remote
    }
    
    public func getPosts() async throws -> PostListResponse {
        return try await remote.getPosts()
    }
    
    public func getPost(id: Int) async throws -> PostResponse {
        return try await remote.getPost(id: id)
    }
    
    public func getPostComments(postId: Int) async throws -> CommentListResponse {
        return try await remote.getPostComments(postId: postId)
    }
}
