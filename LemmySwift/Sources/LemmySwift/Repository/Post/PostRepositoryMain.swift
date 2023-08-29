import Foundation

public protocol PostRepositoryType {
    func getPosts(sort: PostSort) async -> AsyncThrowingStream<[PostDetail], Error>
    func getCommunityPosts(siteUrl: URL, communityId: Int, sort: PostSort) async -> AsyncThrowingStream<[PostDetail], Error>
    func getPost(siteUrl: URL, id: Int, localOnly: Bool) async -> AsyncThrowingStream<PostDetail, Error>
    func votePost(siteURL: URL, request: PostVoteRequest) async throws -> PostDetail
}

public actor PostRepositoryMain: PostRepositoryType, RepositoryType {
    
    private let remote: PostRepositoryRemote
    private let local: PostRepositoryLocal
    private let siteRepository: SiteRepositoryType
    
    init(
        remote: PostRepositoryRemote,
        local: PostRepositoryLocal,
        siteRepository: SiteRepositoryType
    ) {
        self.remote = remote
        self.local = local
        self.siteRepository = siteRepository
    }
    
    public func getPosts(sort: PostSort) async -> AsyncThrowingStream<[PostDetail], Error> {
        return fetchFromSources(
            localDataSource: local.getPosts,
            remoteDataSource: { [weak self] in
                guard let self else { return [PostDetail]() }
                var posts: [PostDetail] = []
                
                let sites = await siteRepository.getSiteUrls(activeOnly: true)
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
                    return _remotePosts
                }
                
                if remoteResponse == nil {
                    return localResponse
                }
                
                return []
            }
        )
    }
    
    public func getCommunityPosts(siteUrl: URL, communityId: Int, sort: PostSort) async -> AsyncThrowingStream<[PostDetail], Error> {
        return fetchFromSources(localDataSource: {
            return [PostDetail]()
        }, remoteDataSource: {
            let postList = try await self.remote.getCommunityPosts(baseUrl: siteUrl, communityId: communityId, sort: sort).posts
            let mappedPosts = await self.local.savePosts(siteUrl: siteUrl, posts: postList ?? [], storeLocally: true)
            return mappedPosts
        }, transform: { localResponse, remoteResponse in
            return remoteResponse
        })
    }
    
    public func getPost(siteUrl: URL, id: Int, localOnly: Bool) -> AsyncThrowingStream<PostDetail, Error> {
        return fetchFromSources { [weak self] in
            await self?.local.getPost(id: id)
        } remoteDataSource: { [weak self] in
            guard localOnly == false else { return Optional<PostDetailResponse>(nil) }
            return try await self?.remote.getPost(baseUrl: siteUrl, id: id).postDetails
        } transform: { [weak local] localResponse, remoteResponse in
            if let _remote = remoteResponse {
                let mappedPost = await local?.savePost(siteUrl: siteUrl, post: _remote)
                return mappedPost
            }
            
            return localResponse
        }
    }
    
    public func votePost(siteURL: URL, request: PostVoteRequest) async throws -> PostDetail {
        let response = try await remote.votePost(siteURL: siteURL, request: request).postDetails
        
        guard let localPost = await local.savePost(siteUrl: siteURL, post: response) else {
            throw NetworkFailure.invalidResponse
        }
        
        return localPost
    }
}
