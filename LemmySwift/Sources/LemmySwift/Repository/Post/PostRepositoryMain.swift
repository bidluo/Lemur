import Foundation

public protocol PostRepositoryType {
    func getPosts() async throws -> PostListResponse
}

public class PostRepositoryMain: PostRepositoryType {
    
    private let remote: PostRepositoryRemote
    
    init(remote: PostRepositoryRemote) {
        self.remote = remote
    }
    
    public func getPosts() async throws -> PostListResponse {
        return try await remote.getPosts()
    }
}
