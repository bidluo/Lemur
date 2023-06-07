import Foundation
import Common
import Observation

@Observable
class CommunityListStore {
    
    @ObservationIgnored
    @UseCase private var useCase: GetCommunitiesUseCase
    
    var rows: [String] = []
    
    init() {
    }
    
    func load() async throws {
        let communities = try await useCase.call(input: ())
        rows = communities.communities.map { String($0.id) }
    }
    
}
