import Foundation

public protocol PostRepositoryType {
    func getPosts() -> AsyncThrowingStream<SourcedResult<PostListResponse>, Error>
    func getPost(id: Int) -> AsyncThrowingStream<PostDetailResponse, Error>
}

public class PostRepositoryMain: PostRepositoryType, RepositoryType {
    
    private let remote: PostRepositoryRemote
    private let local: PostRepositoryLocal
    
    init(remote: PostRepositoryRemote, local: PostRepositoryLocal) {
        self.remote = remote
        self.local = local
    }
    
    public func getPosts() -> AsyncThrowingStream<SourcedResult<PostListResponse>, Error> {
        return fetchFromSources(
            localDataSource: local.getPosts,
            remoteDataSource: remote.getPosts,
            transform: { local, remote in
                if let _remotePosts = remote?.rawPosts {
                    await self.local.savePosts(posts: _remotePosts)
                }
                if remote == nil {
                    return .loaded(local, .local)
                }
                
                return .loaded(remote, .remote)
            }
        )
    }
    
    public func getPost(id: Int) -> AsyncThrowingStream<PostDetailResponse, Error> {
        return fetchFromSources { [weak self] in
            await self?.local.getPost(id: id)
        } remoteDataSource: { [weak self] in
            try await self?.remote.getPost(id: id).rawPostDetails
        } transform: { local, remote in
            if let _remote = remote {
                await self.local.savePosts(posts: [_remote])
            }
            return remote ?? local
        }
    }
}

public enum SourcedResult<T> {
    case loaded(T?, DataSource)
}

public enum DataSource {
    case local, remote
}
