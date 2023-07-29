import Foundation
import Common
import LemmySwift
import Factory

class GetPostUseCase: UseCaseStreamType {
    
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
    
    func call(input: Input) -> AsyncThrowingStream<Result, Error> {
        let stream = repository.getPost(id: input.id)
        
        return mapAsyncStream(stream) { post -> PostSummary in
            return try PostSummary(post: post)
        }
    }
}
