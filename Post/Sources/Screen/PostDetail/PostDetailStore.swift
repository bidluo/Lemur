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
        for try await post in try await getPostUseCase.call(input: .init(id: postId)) {
            self.post = post
        }
        
        let _comments = try await getCommentsUseCase.call(input: .init(postId: postId))
        self.comments = _comments.comments
    }
}
