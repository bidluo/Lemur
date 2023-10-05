import Foundation
import Common
import LemmySwift
import Factory

class CreateCommentUseCase: UseCaseType {
    
    @Injected(\.commentRepository) private var repository: CommentRepositoryType
    @Injected(\.keychain) private var keychain: KeychainType
    
    struct Input {
        let siteUrl: URL
        let content: String
        let postId: Int
        let parentId: Int?
        
        init(siteUrl: URL, content: String, postId: Int, parentId: Int?) {
            self.siteUrl = siteUrl
            self.content = content
            self.postId = postId
            self.parentId = parentId
        }
    }
    
    struct Result {
        public let score: Int
        public let myVote: Int
    }
    
    required init() {
    }
    
    func call(input: Input) async throws -> Result {
        let comment = try await repository.createComment(
            siteUrl: input.siteUrl,
            request: CommentCreateRequest(
                content: input.content,
                postId: input.postId,
                parentId: input.parentId,
                auth: keychain.getToken(for: input.siteUrl)
            )
        )
        
        return Result(score: comment.score ?? 0, myVote: comment.myVote ?? 0)
    }
}
