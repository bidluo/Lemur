import Foundation
import Common
import Observation

@Observable
class PostDetailStore {
    
    @ObservationIgnored
    @UseCaseStream private var getPostUseCase: GetPostUseCase
    
    @ObservationIgnored
    @UseCaseStream private var getCommentsUseCase: GetPostCommentsUseCase
    
    public var sortItems: [GetPostCommentsUseCase.Sort] { return [.hot, .top, .old, .new] }
    
    var post: PostSummary?
    var comments: [CommentContent] = []
    var selectedSort: GetPostCommentsUseCase.Sort = .hot
    
    private let postId: Int
    private let siteUrl: URL
    
    init(siteUrl: URL, id: Int) {
        self.postId = id
        self.siteUrl = siteUrl
    }
    
    func load() async throws {
        try await withThrowingDiscardingTaskGroup { [weak self] group in
            guard let self else { return }
            group.addTask {
                for try await post in await self.getPostUseCase.call(input: .init(id: self.postId, siteUrl: self.siteUrl)) {
                    self.post = post
                }
            }
            
            group.addTask {
                try await self.loadComments()
            }
        }
    }
    
    func loadComments() async throws {
        for try await comments in await self.getCommentsUseCase.call(
            input: .init(baseUrl: self.siteUrl, postId: self.postId, sort: self.selectedSort)
        ) {
            self.comments = comments.comments
        }
    }
}
