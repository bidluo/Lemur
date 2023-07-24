import Foundation
import Common
import Observation

@Observable
class PostListStore {
    
    @ObservationIgnored
    @UseCase private var useCase: GetPostListUseCase
    
    var rows: [PostSummary] = []
    
    init() {
    }
    
    func load() async throws {
//        let posts = try await useCase.call(input: ())
//        rows = posts.posts
        for try await posts in try await useCase.call(input: ()) {
            rows = posts.posts
        }
    }
    
}
