import Foundation
import Common
import Observation

@Observable
class SignInStore {
    
    @ObservationIgnored @UseCase private var useCase: SignInUseCase
    @ObservationIgnored @UseCase private var querySiteUseCase: QuerySiteUseCase
    @ObservationIgnored @UseCase private var getSitesUseCase: GetSitesUseCase
    @ObservationIgnored @UseCase var addServerUseCase: AddServerUseCase
    
    var username: String = ""
    var password: String = ""
    
    var siteSelectorDisplay: String = ""
    var userSiteUrlString: String = ""
    var shouldShowAddServerField = false
    var loaded = false
    
    var sites: [GetSitesUseCase.Result.Site] = []
    
    private var selectedSiteUrl: URL?
    private(set) var selectedSiteName: String?
    private(set) var selectedSiteDescription: String?
    
    init() {
    }
    
    func load() async throws {
        defer {
            loaded = true
        }
        
        sites = try await getSitesUseCase.call(input: .init()).sites
        
        if sites.isEmpty {
            shouldShowAddServerField = true
        }
        
        if userSiteUrlString.isEmpty, let firstSite = sites.first {
            userSiteUrlString = firstSite.urlString
            siteSelectorDisplay = firstSite.name
        }
    }
    
    func userSiteUrlStringUpdated() async throws {
        guard userSiteUrlString.isEmpty == false else { return }
        let result = try await querySiteUseCase.call(input: .init(siteUrlString: userSiteUrlString))
        self.selectedSiteUrl = result.url
        self.selectedSiteName = result.name
        self.selectedSiteDescription = result.description
    }
    
    func submit() async throws {
        // Validation? 10 min chars
        try await addServerUseCase.call(input: .init(url: selectedSiteUrl))
        try await useCase.call(input: .init(baseUrl: selectedSiteUrl, username: username, password: password))
    }
}
