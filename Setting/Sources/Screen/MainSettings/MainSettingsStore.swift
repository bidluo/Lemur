import Foundation
import Common
import Observation

@Observable
class MainSettingsStore {
    
    @ObservationIgnored @UseCase private var getSitesUseCase: GetSitesUseCase
    
    var sites: [GetSitesUseCase.Result.Site] = []
    var presentedSheet: PresentedSheet?
    
    enum PresentedSheet: Identifiable, Hashable {
        case addServer
        
        var id: Int { return hashValue }
    }
    
    init() {
    }
    
    func load() async throws {
        sites = try await getSitesUseCase.call(input: .init()).sites
    }
}
