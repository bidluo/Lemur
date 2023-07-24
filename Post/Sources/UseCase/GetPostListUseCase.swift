import Foundation
import Common
import LemmySwift
import Factory

class GetPostListUseCase: UseCaseType {
    
    @Injected(\.postRepository) private var repository: PostRepositoryType
    
    typealias Input = Void
    typealias Result = AsyncThrowingStream<ResultObject, Error>
    struct ResultObject {
        public let posts: [PostSummary]
    }
    
    required init() {
    }
    
    func call(input: Void) async throws -> Result {
        let stream = repository.getPosts()
        
        return mapAsyncStream(stream) { postList -> ResultObject in
            let posts = postList.posts?.compactMap { post in
                return try? PostSummary(post: post)
            } ?? []
            
            return ResultObject(posts: posts)
        }
    }
}
