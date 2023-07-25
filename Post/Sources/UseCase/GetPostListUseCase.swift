import Foundation
import Common
import LemmySwift
import Factory

class GetPostListUseCase: UseCaseStreamType {
    
    @Injected(\.postRepository) private var repository: PostRepositoryType
    
    typealias Input = Void
    struct Result {
        public let posts: [PostSummary]
    }
    
    required init() {
    }
    
    func call(input: Void) -> AsyncThrowingStream<Result, Error> {
        let stream = repository.getPosts()
        
        return mapAsyncStream(stream) { postList -> Result in
            let posts = postList.posts?.compactMap { post in
                return try? PostSummary(post: post)
            } ?? []
            
            return Result(posts: posts)
        }
    }
}
