import Foundation
import Common
import LemmySwift
import Factory

class CommentVoteUseCase: UseCaseType {
    
    @Injected(\.postRepository) private var repository: PostRepositoryType
    
    struct Input {
        public let siteUrl: URL?
        public let postId: Int?
        public let commentId: Int?
        public let voteType: VoteType
    }
    
    typealias Result = Void
    
    required init() {
    }
    
    func call(input: Input) async -> Result {
        return ()
    }
}
