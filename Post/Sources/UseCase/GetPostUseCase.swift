import Foundation
import Common
import LemmySwift
import Factory

class GetPostUseCase: UseCaseType {
    
    @Injected(\.postRepository) private var repository: PostRepositoryType
    
    struct Input {
        let id: Int
    }
    
    typealias Result = AsyncThrowingStream<PostSummary, Error>
    
    enum Failure: LocalizedError {
        case invalidCreatorId
        case invalidCommunityId
        case invalidPost
    }
    
    required init() {}
    
    func call(input: Input) async throws -> Result {
        let stream = repository.getPost(id: input.id)
        
        return mapAsyncStream(stream) { post -> PostSummary in
            return try PostSummary(post: post)
        }
    }
}
