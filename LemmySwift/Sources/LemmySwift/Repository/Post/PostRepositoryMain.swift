import Foundation

public protocol PostRepositoryType {
    func getPosts(sort: PostSort) async -> AsyncThrowingStream<SourcedResult<[PostDetail]>, Error>
    func getPost(id: Int) async -> AsyncThrowingStream<PostDetail, Error>
}

public actor PostRepositoryMain: PostRepositoryType, RepositoryType {
    
    private let remote: PostRepositoryRemote
    private let local: PostRepositoryLocal
    
    init(remote: PostRepositoryRemote, local: PostRepositoryLocal) {
        self.remote = remote
        self.local = local
    }
    
    public func getPosts(sort: PostSort) -> AsyncThrowingStream<SourcedResult<[PostDetail]>, Error> {
        return fetchFromSources(
            localDataSource: local.getPosts,
            remoteDataSource: { [weak self] in
                try await self?.remote.getPosts(sort: sort)
            },
            transform: { [weak local] localResponse, remoteResponse in
                if let _remotePosts = remoteResponse?.posts {
                    let mappedPosts = await local?.savePosts(posts: _remotePosts)
                    return .loaded(mappedPosts, .remote)
                }
                
                if remoteResponse == nil {
                    return .loaded(localResponse, .local)
                }
                
                return .loaded([], .remote)
            }
        )
    }
    
    public func getPost(id: Int) -> AsyncThrowingStream<PostDetail, Error> {
        return fetchFromSources { [weak self] in
            await self?.local.getPost(id: id)
        } remoteDataSource: { [weak self] in
            try await self?.remote.getPost(id: id).postDetails
        } transform: { [weak local] localResponse, remoteResponse in
            if let _remote = remoteResponse {
                let mappedPost = await local?.savePosts(posts: [_remote])
                return mappedPost?.first
            }
            
            return localResponse
        }
    }
}
