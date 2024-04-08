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
    
    let siteUrl: URL
    var post: PostSummary?
    private(set) var comments: [CommentContent] = []
    private(set) var pendingComments: [CommentContent] = []
    var selectedSort: GetPostCommentsUseCase.Sort = .hot
    
    private let postId: Int
    private var commentsLoading: Bool = false
    private var needsLoad: Bool = true
    
    init(siteUrl: URL, id: Int) {
        self.postId = id
        self.siteUrl = siteUrl
    }
    
    func load() async throws {
        guard needsLoad else { return }
        defer { needsLoad = false }
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
    
    func setNewComments() {
        self.comments = pendingComments
        self.pendingComments = []
    }
    
    func loadComments() async throws {
        guard commentsLoading == false, needsLoad else { return }
        commentsLoading = true
        defer { commentsLoading = false; needsLoad = false }
        
        for try await comments in await self.getCommentsUseCase.call(
            input: .init(baseUrl: self.siteUrl, postId: self.postId, sort: self.selectedSort)
        ) {
            if self.comments.isEmpty {
                self.comments = comments.comments
            } else {
                self.pendingComments = comments.comments
            }
        }
    }
}
