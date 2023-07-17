import Foundation
import Common
import Observation

@Observable
class PostDetailStore {
    
    @ObservationIgnored
    @UseCase private var useCase: GetPostUseCase
    
    var post: PostSummary?
    
    private let postId: Int
    
    init(id: Int) {
        self.postId = id
    }
    
    func load() async throws {
        let _post = try await useCase.call(input: .init(id: postId))
        self.post = _post
    }
}
