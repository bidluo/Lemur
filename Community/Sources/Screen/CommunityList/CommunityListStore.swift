import Foundation
import Common
import Observation

@Observable
class CommunityListStore {
    
    @ObservationIgnored @UseCase private var useCase: GetCommunitiesUseCase
    @ObservationIgnored @UseCase private var getSitesUseCase: GetSitesUseCase
    
    var sites: [GetSitesUseCase.Result.Site] = []
    var rows: [GetCommunitiesUseCase.Result.Community] = []
    var needsLoad: Bool = true
    var selectedSort: GetCommunitiesUseCase.Sort = .hot
    
    var selectedSite: GetSitesUseCase.Result.Site?
    
    public let mainItems = GetCommunitiesUseCase.Sort.mainItems
    public let commentItems = GetCommunitiesUseCase.Sort.commentItems
    public let topItems = GetCommunitiesUseCase.Sort.topItems
    
    init() {
    }
    
    func load() async throws {
        guard needsLoad else { return }
        defer {
            needsLoad = false
        }
        let _sites = try await getSitesUseCase.call(input: .init(activeOnly: false))
        self.sites = _sites.sites
        selectedSite = _sites.sites.first
    }
    
    func reload() async throws {
        try await loadCommunities()
    }
    
    func loadCommunities() async throws {
        guard let siteUrl = selectedSite?.url else { return }
        let communities = try await useCase.call(input: .init(siteUrl: siteUrl, sort: selectedSort))
        rows = communities.communities
    }
}
