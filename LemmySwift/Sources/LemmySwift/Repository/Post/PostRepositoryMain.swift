import Foundation

public protocol PostRepositoryType {
    func getPosts(sort: PostSort) async -> AsyncThrowingStream<SourcedResult<PostListResponse>, Error>
    func getPost(id: Int) async -> AsyncThrowingStream<PostDetailResponse, Error>
}

public actor PostRepositoryMain: PostRepositoryType, RepositoryType {
    
    private let remote: PostRepositoryRemote
    private let local: PostRepositoryLocal
    
    init(remote: PostRepositoryRemote, local: PostRepositoryLocal) {
        self.remote = remote
        self.local = local
    }
    
    public func getPosts(sort: PostSort) -> AsyncThrowingStream<SourcedResult<PostListResponse>, Error> {
        return fetchFromSources(
            localDataSource: local.getPosts,
            remoteDataSource: { [weak self] in
                try await self?.remote.getPosts(sort: sort)
            },
            transform: { [weak local] localResponse, remoteResponse in
                if let _remotePosts = remoteResponse?.rawPosts {
                    await local?.savePosts(posts: _remotePosts)
                }
                
                if remoteResponse == nil {
                    return .loaded(localResponse, .local)
                }
                
                return .loaded(remoteResponse, .remote)
            }
        )
    }
    
    public func getPost(id: Int) -> AsyncThrowingStream<PostDetailResponse, Error> {
        return fetchFromSources { [weak self] in
            await self?.local.getPost(id: id)
        } remoteDataSource: { [weak self] in
            try await self?.remote.getPost(id: id).rawPostDetails
        } transform: { [weak local] localResponse, remoteResponse in
            if let _remote = remoteResponse {
                await local?.savePosts(posts: [_remote])
            }
            
            return remoteResponse ?? localResponse
        }
    }
}
