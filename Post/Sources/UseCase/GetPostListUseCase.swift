import Foundation
import Common
import LemmySwift
import Factory

class GetPostListUseCase: UseCaseType {
    
    @Injected(\.postRepository) private var repository: PostRepositoryType
    
    typealias Input = Void
    struct Result {
        
        public let posts: [Post]
        
        public struct Post {
            public let title: String?
        }
    }
    
    required init() {
    }
    
    func call(input: Void) async throws -> Result {
        let posts = try await repository.getPosts().posts?.map { post in
            Result.Post(title: post.post?.name)
        } ?? []
        
        return Result(posts: posts)
    }
    
}
