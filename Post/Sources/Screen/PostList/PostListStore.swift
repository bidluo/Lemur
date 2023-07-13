import Foundation
import Common
import Observation

@Observable
class PostListStore {
    
    @ObservationIgnored
    @UseCase private var useCase: GetPostListUseCase
    
    var rows: [String] = []
    
    init() {
    }
    
    func load() async throws {
        let posts = try await useCase.call(input: ())
        rows = posts.posts.compactMap { $0.title }
    }
    
}
