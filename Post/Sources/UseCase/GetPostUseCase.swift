import Foundation
import Common
import LemmySwift
import Factory

class GetPostUseCase: UseCaseType {
    
    @Injected(\.postRepository) private var repository: PostRepositoryType
    
    struct Input {
        let id: Int
    }
    
    typealias Result = PostSummary
    
    enum Failure: LocalizedError {
        case invalidCreatorId
        case invalidCommunityId
        case invalidPost
    }
    
    required init() {}
    
    func call(input: Input) async throws -> Result {
        let post = try await repository.getPost(id: input.id)
        
        return try Result(post: post.postDetails)
    }
}
