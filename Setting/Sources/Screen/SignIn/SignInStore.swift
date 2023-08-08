import Foundation
import Common
import Observation

@Observable
class SignInStore {
    
    @ObservationIgnored @UseCase private var useCase: SignInUseCase
    @ObservationIgnored @UseCase private var querySiteUseCase: QuerySiteUseCase
    @ObservationIgnored @UseCase var addServerUseCase: AddServerUseCase
    
    var username: String = ""
    var password: String = ""
    
    var serverUrl: String = ""
    
    private var selectedSiteUrl: URL?
    private(set) var selectedSiteName: String?
    private(set) var selectedSiteDescription: String?
    
    init() {
    }
    
    func load() async throws {
        // Load availble servers
    }
    
    func serverUrlUpdated() async throws {
        guard serverUrl.isEmpty == false else { return }
        let result = try await querySiteUseCase.call(input: .init(siteUrlString: serverUrl))
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
