import Foundation
import Common
import LemmySwift
import Factory

class CommentVoteUseCase: UseCaseType {
    
    @Injected(\.commentRepository) private var repository: CommentRepositoryType
    @Injected(\.keychain) private var keychain: KeychainType
    
    struct Input {
        public let siteUrl: URL
        public let commentId: Int
        public let voteType: VoteType
    }
    
    struct Result {
        public let score: Int
        public let myVote: Int
    }
    
    required init() {
    }
    
    func call(input: Input) async throws -> Result {
        let localComment = await repository.getComment(siteUrl: input.siteUrl, commentId: input.commentId, localOnly: true)
        var existingVote: Int?
        for try await post in localComment {
            existingVote = post.myVote ?? 0
        }
        
        let score = switch input.voteType {
        case .down: existingVote == -1 ? 0 : -1
        case .up: existingVote == 1 ? 0 : 1
        }
        
        let comment = try await repository.voteComment(
            siteUrl: input.siteUrl,
            request: .init(commentId: input.commentId, score: score, auth: keychain.getToken(for: input.siteUrl))
        )
        
        return Result(score: comment.score ?? 0, myVote: comment.myVote ?? 0)
    }
}
