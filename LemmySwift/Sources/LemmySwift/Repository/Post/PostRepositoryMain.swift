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
        return fetchFromSources(localDataSource: local.getPosts, remoteDataSource: remote.getPosts, transform: { [weak self] local, remote in
            try await self?.local.savePosts(posts: remote?.rawPosts ?? [])
            return remote ?? local!
        })
    }
    
    public func getPost(id: Int) -> AsyncThrowingStream<PostDetailResponse, Error> {
        return fetchFromSources { [weak self] in
            try await self?.local.getPost(id: id)
        } remoteDataSource: { [weak self ] in
            try await self?.remote.getPost(id: id).postDetails
        } transform: { local, remote in
            return remote ?? local!
        }
    }
    
    public func getPostComments(postId: Int) async throws -> CommentListResponse {
        return try await remote.getPostComments(postId: postId)
    }
}

protocol RepositoryType {
    
}

extension RepositoryType {
    func fetchFromSources<LocalType, RemoteType, ResultType>(
        localDataSource: @escaping () async throws -> LocalType?,
        remoteDataSource: @escaping () async throws -> RemoteType?,
        transform: @escaping (LocalType?, RemoteType?) async throws -> ResultType
    ) -> AsyncThrowingStream<ResultType, Error> {
        let stream = AsyncThrowingStream<ResultType, Error> { continuation in
            Task {
                let localData = try await localDataSource()
                let localResult = try await transform(localData, nil)
                continuation.yield(localResult)
                
                let remoteData = try await remoteDataSource()
                let bothResult = try await transform(localData, remoteData)
                
                continuation.yield(bothResult)
                continuation.finish()
            }
        }
        
        return stream
    }
}
