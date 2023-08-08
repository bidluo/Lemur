import Foundation

public protocol PostRepositoryType {
    func getPosts(sort: PostSort) async -> AsyncThrowingStream<SourcedResult<[PostDetail]>, Error>
    func getPost(siteUrl: URL, id: Int) async -> AsyncThrowingStream<PostDetail, Error>
}

public actor PostRepositoryMain: PostRepositoryType, RepositoryType {
    
    private let remote: PostRepositoryRemote
    private let local: PostRepositoryLocal
    private let siteRepository: SiteRepositoryType
    
    init(remote: PostRepositoryRemote, local: PostRepositoryLocal, siteRepository: SiteRepositoryType) {
        self.remote = remote
        self.local = local
        self.siteRepository = siteRepository
    }
    
    public func getPosts(sort: PostSort) async -> AsyncThrowingStream<SourcedResult<[PostDetail]>, Error> {
        let sites = await siteRepository.getSiteUrls(activeOnly: true)
        return fetchFromSources(
            localDataSource: local.getPosts,
            remoteDataSource: { [weak self] in
                guard let self else { return [PostDetail]() }
                var posts: [PostDetail] = []
                
                try await withThrowingTaskGroup(of: [PostDetail].self) { group in
                    for site in sites {
                        group.addTask {
                            let postList = try await self.remote.getPosts(baseUrl: site, sort: sort).posts
                            let mappedPosts = await self.local.savePosts(siteUrl: site, posts: postList ?? [])
                            return mappedPosts
                        }
                    }
                    
                    for try await postList in group {
                        posts.append(contentsOf: postList)
                    }
                }
                
                return posts
            },
            transform: { localResponse, remoteResponse in
                if let _remotePosts = remoteResponse {
                    return .loaded(_remotePosts, .remote)
                }
                
                if remoteResponse == nil {
                    return .loaded(localResponse, .local)
                }
                
                return .loaded([], .remote)
            }
        )
    }
    
    public func getPost(siteUrl: URL, id: Int) -> AsyncThrowingStream<PostDetail, Error> {
        return fetchFromSources { [weak self] in
            await self?.local.getPost(id: id)
        } remoteDataSource: { [weak self] in
            try await self?.remote.getPost(baseUrl: siteUrl, id: id).postDetails
        } transform: { [weak local] localResponse, remoteResponse in
            if let _remote = remoteResponse {
                let mappedPost = await local?.savePosts(siteUrl: siteUrl, posts: [_remote])
                return mappedPost?.first
            }
            
            return localResponse
        }
    }
}
