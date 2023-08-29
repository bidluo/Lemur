import Foundation
import Common
import LemmySwift
import Factory

class PostVoteUseCase: UseCaseType {
    
    @Injected(\.postRepository) private var repository: PostRepositoryType
    @Injected(\.keychain) private var keychain: KeychainType
    
    struct Input {
        public let siteUrl: URL
        public let postId: Int
        public let voteType: VoteType
    }
    
    typealias Result = PostSummary
    
    required init() {
    }
    
    func call(input: Input) async throws -> Result {
        let localPost = await repository.getPost(siteUrl: input.siteUrl, id: input.postId, localOnly: true)
        var existingVote: Int?
        for try await post in localPost {
            existingVote = post.myVote ?? 0
        }
        
        let score = switch input.voteType {
        case .down: existingVote == -1 ? 0 : -1
        case .up: existingVote == 1 ? 0 : 1
        }
        
        let post = try await repository.votePost(
            siteURL: input.siteUrl,
            request: .init(postId: input.postId, score: score, auth: keychain.getToken(for: input.siteUrl))
        )
        
        return try PostSummary(post: post)
    }
}
