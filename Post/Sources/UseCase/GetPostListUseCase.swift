import Foundation
import Common
import LemmySwift
import Factory

class GetPostListUseCase: UseCaseStreamType {
    
    @Injected(\.postRepository) private var repository: PostRepositoryType
    
    struct Input {
        public let sort: Sort
    }
    
    struct Result {
        public let posts: [PostSummary]
    }
    
    required init() {
    }
    
    typealias Sort = LemmySwift.PostSort
    
    func call(input: Input) async -> AsyncThrowingStream<Result, Error> {
        let stream = await repository.getPosts(sort: input.sort)
        
        return mapAsyncStream(stream) { result -> Result in
            guard case let .loaded(postList, source) = result else { return Result(posts: [])}
            let posts = postList?.posts?.compactMap { post in
                return try? PostSummary(post: post)
            } ?? []
            
            return Result(posts: posts)
        }
    }
}
