import Foundation
import Common
import Observation

@Observable
class PostDetailStore {
    
    @ObservationIgnored
    @UseCaseStream private var getPostUseCase: GetPostUseCase
    
    @ObservationIgnored
    @UseCaseStream private var getCommentsUseCase: GetPostCommentsUseCase
    
    var post: PostSummary?
    var comments: [CommentContent] = []
    
    private let postId: Int
    
    init(id: Int) {
        self.postId = id
    }
    
    func load() async throws {
        try await withThrowingDiscardingTaskGroup { [weak self] group in
            guard let self else { return }
            group.addTask {
                for try await post in self.getPostUseCase.call(input: .init(id: self.postId)) {
                    self.post = post
                }
            }
            
            group.addTask {
                for try await comments in self.getCommentsUseCase.call(input: .init(postId: self.postId)) {
                    self.comments = comments.comments
                }
            }
        }
    }
}
