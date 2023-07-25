import Foundation

public protocol PostRepositoryType {
    func getPosts() -> AsyncThrowingStream<PostList, Error>
    func getPost(id: Int) -> AsyncThrowingStream<PostDetailResponse, Error>
    func getPostComments(postId: Int) async throws -> CommentListResponse
}

public class PostRepositoryMain: PostRepositoryType, RepositoryType {
    
    private let remote: PostRepositoryRemote
    private let local: PostRepositoryLocal
    
    init(remote: PostRepositoryRemote, local: PostRepositoryLocal) {
        self.remote = remote
        self.local = local
    }
    
    public func getPosts() -> AsyncThrowingStream<PostList, Error> {
        return fetchFromSources(
            localDataSource: local.getPosts,
            remoteDataSource: remote.getPosts,
            transform: { [weak self] local, remote in
                try? await self?.local.savePosts(posts: remote?.rawPosts ?? [])
                return remote ?? local
            }
        )
    }
    
    public func getPost(id: Int) -> AsyncThrowingStream<PostDetailResponse, Error> {
        return fetchFromSources { [weak self] in
            try await self?.local.getPost(id: id)
        } remoteDataSource: { [weak self] in
            try await self?.remote.getPost(id: id).postDetails
        } transform: { local, remote in
            return remote ?? local
        }
    }
    
    public func getPostComments(postId: Int) async throws -> CommentListResponse {
        return try await remote.getPostComments(postId: postId)
    }
}
