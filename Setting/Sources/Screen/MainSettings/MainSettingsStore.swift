import Foundation
import Common
import Observation

@Observable
class MainSettingsStore {
    
    @ObservationIgnored @UseCase private var getSitesUseCase: GetSitesUseCase
    @ObservationIgnored @UseCase private var getLoggedInUsersUseCase: GetLoggedInUsersUseCase
    
    var sites: [GetSitesUseCase.Result.Site] = []
    var loggedInUsers: [GetLoggedInUsersUseCase.Result.LoggedInUser] = []
    var presentedSheet: PresentedSheet?
    
    enum PresentedSheet: Identifiable, Hashable {
        case addServer
        case signIn
        
        var id: Int { return hashValue }
    }
    
    init() {
    }
    
    func load() async throws {
        sites = try await getSitesUseCase.call(input: .init()).sites
        loggedInUsers = try await getLoggedInUsersUseCase.call().loggedInUsers
    }
}
