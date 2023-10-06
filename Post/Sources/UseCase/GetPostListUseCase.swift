import Foundation
import Common
import LemmySwift
import Factory

class GetPostListUseCase: UseCaseStreamType {
    
    @Injected(\.postRepository) private var repository: PostRepositoryType
    
    struct Input {
        public let siteUrl: URL?
        public let communityId: Int?
        public let sort: Sort
        public let page: Int
    }
    
    struct Result {
        public let posts: [PostSummary]
    }
    
    required init() {
    }
    
    typealias Sort = LemmySwift.PostSort
    
    func call(input: Input) async -> AsyncThrowingStream<Result, Error> {
        
        let request = GetPostRequest(sort: input.sort, page: input.page)
        
        let stream: AsyncThrowingStream<[PostDetail], Error>
        if let siteUrl = input.siteUrl, let communityId = input.communityId {
            stream = await repository.getCommunityPosts(siteUrl: siteUrl, communityId: communityId, request: request)
        } else {
            stream = await repository.getPosts(request: request)
        }
        
        return await mapAsyncStream(stream) { postList -> Result in
            let posts = postList.compactMap { post in
                return try? PostSummary(post: post)
            }
            
            return Result(posts: posts)
        }
    }
}
