import Foundation
import Common
import Observation

@Observable
class PostDetailStore {
    
    @ObservationIgnored
    @UseCase private var getPostUseCase: GetPostUseCase
    
    @ObservationIgnored
    @UseCase private var getCommentsUseCase: GetPostCommentsUseCase
    
    var post: PostSummary?
    var comments: [CommentContent] = []
    
    private let postId: Int
    
    init(id: Int) {
        self.postId = id
    }
    
    func load() async throws {
        async let _post = getPostUseCase.call(input: .init(id: postId))
        async let _comments = getCommentsUseCase.call(input: .init(postId: postId))
        self.post = try await _post
        self.comments = try await _comments.comments
    }
}
