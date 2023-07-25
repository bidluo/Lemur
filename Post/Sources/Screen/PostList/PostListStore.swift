import Foundation
import Common
import Observation

@Observable
class PostListStore {
    
    @ObservationIgnored
    @UseCaseStream private var useCase: GetPostListUseCase
    
    var rows: [PostSummary] = []
    
    init() {
    }
    
    func load() async throws {
        for try await posts in useCase.call(input: ()) {
            rows = posts.posts
        }
    }
}
