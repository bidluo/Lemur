import Foundation
import Common
import LemmySwift
import Factory

class GetPostListUseCase: UseCaseType {
    
    @Injected(\.postRepository) private var repository: PostRepositoryType
    
    typealias Input = Void
    struct Result {
        
        public let posts: [PostSummary]
    }
    
    required init() {
    }
    
    func call(input: Void) async throws -> Result {
        let posts = try await repository.getPosts().posts?.compactMap { post -> PostSummary? in
            return try? PostSummary(post: post)
        } ?? []
        
        return Result(posts: posts)
    }
}
