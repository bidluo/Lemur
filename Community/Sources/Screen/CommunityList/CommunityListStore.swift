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
    
    var selectedSite: GetSitesUseCase.Result.Site?
    
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
    
    func loadCommunities() async throws {
        guard let siteUrl = selectedSite?.url else { return }
        let communities = try await useCase.call(input: .init(siteUrl: siteUrl))
        rows = communities.communities
    }
}
