import Foundation

public protocol CommunityRepositoryType {
    func getCommunities(siteUrl: URL) async throws -> [Community]
    func getSubscribedCommunities() async -> AsyncThrowingStream<SourcedResult<[Site: [Community]]>, Error>
}

public class CommunityRepositoryMain: CommunityRepositoryType, RepositoryType {
    
    private let remote: CommunityRepositoryRemote
    private let local: CommunityRepositoryLocal
    private let siteRepository: SiteRepositoryType
    
    init(remote: CommunityRepositoryRemote, local: CommunityRepositoryLocal, siteRepository: SiteRepositoryType) {
        self.remote = remote
        self.local = local
        self.siteRepository = siteRepository
    }
    
    public func getCommunities(siteUrl: URL) async throws -> [Community] {
        let communityList = try? await self.remote.getCommunities(baseUrl: siteUrl).communities
        let mappedPosts = await self.local.mapCommunities(siteUrl: siteUrl, communities: communityList ?? [], saveLocally: false)
        return mappedPosts
    }
    
    public func getSubscribedCommunities() async -> AsyncThrowingStream<SourcedResult<[Site: [Community]]>, Error>  {
        let sites = await siteRepository.getSites(activeOnly: true)
        return fetchFromSources(
            localDataSource: {
                return [Site: [Community]]()
            },
            remoteDataSource: { [weak self] in
                guard let self else { return [Site: [Community]]() }
                var communities: [Site: [Community]] = [:]
                
                try await withThrowingTaskGroup(of: (Site, [Community]).self) { group in
                    for site in sites {
                        group.addTask {
                            let communityList = try? await self.remote.getSubscribedCommunities(baseUrl: site.url).communities
                            let mappedPosts = await self.local.mapCommunities(siteUrl: site.url, communities: communityList ?? [], saveLocally: false)
                            return (site, mappedPosts)
                        }
                    }
                    
                    for try await pair in group {
                        communities[pair.0] = pair.1
                    }
                }
                
                return communities
            },
            transform: { localResponse, remoteResponse in
                if let _remoteCommunities = remoteResponse {
                    return .loaded(_remoteCommunities, .remote)
                }
                
                if remoteResponse == nil {
                    return .loaded(localResponse, .local)
                }
                
                return .loaded([:], .remote)
            }
        )
    }
}
