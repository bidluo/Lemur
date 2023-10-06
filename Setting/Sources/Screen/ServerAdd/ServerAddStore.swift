import Foundation
import Common
import Observation

@Observable
class ServerAddStore {
    
    @ObservationIgnored
    @UseCase private var useCase: QuerySiteUseCase
    
    @ObservationIgnored
    @UseCase private var addServerUseCase: AddServerUseCase
    
    var urlString: String = ""
    var isSearching: Bool = false
    
    private(set) var serverName: String = ""
    private(set) var serverDescription: String = ""
    private var serverUrl: URL?
    
    init() {
    }
    
    func search() async throws {
        isSearching = true
        defer {
            isSearching = false
        }
        guard urlString.isEmpty == false else {
            serverName = ""
            serverDescription = ""
            return
        }
        
        let site = try await useCase.call(input: QuerySiteUseCase.Input(siteUrlString: urlString))
        serverName = site.name
        serverDescription = site.description
        serverUrl = site.url
    }
    
    func submit() async throws {
        try await addServerUseCase.call(input: AddServerUseCase.Input(url: serverUrl))
    }
}
