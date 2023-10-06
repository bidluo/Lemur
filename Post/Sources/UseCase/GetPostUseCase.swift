import Foundation
import Common
import LemmySwift
import Factory

class GetPostUseCase: UseCaseStreamType {
    
    @Injected(\.postRepository) private var repository: PostRepositoryType
    
    struct Input {
        let id: Int
        let siteUrl: URL
    }
    
    typealias Result = PostSummary
    
    enum Failure: LocalizedError {
        case invalidCreatorId
        case invalidCommunityId
        case invalidPost
    }
    
    required init() {}
    
    func call(input: Input) async -> AsyncThrowingStream<Result, Error> {
        let stream = await repository.getPost(siteUrl: input.siteUrl, id: input.id, localOnly: false)
        
        return await mapAsyncStream(stream) { post -> PostSummary in
            return try PostSummary(post: post)
        }
    }
}
