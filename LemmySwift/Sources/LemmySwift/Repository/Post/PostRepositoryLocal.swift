import Foundation
import SwiftData

public class PostRepositoryLocal {
    
    private let container: ModelContainer
    
    init(container: ModelContainer) {
        self.container = container
    }
    
    @MainActor
    public func getPosts() async throws -> PostListLocal {
        let posts = try container.mainContext.fetch(FetchDescriptor<PostDetailResponseLocal>())
        return PostListLocal(posts: posts)
    }
    
    @MainActor
    public func savePosts(posts: [PostDetailResponseRemote]) async throws {
        posts.forEach { [weak container] post in
            guard let localPost = PostDetailResponseLocal(remote: post) else { return }
            container?.mainContext.insert(object: localPost)
        }
        try container.mainContext.save()
    }
    
    @MainActor
    public func getPost(id: Int) async throws -> PostDetailResponse? {
        let postFetch = FetchDescriptor<PostDetailResponseLocal>(
            predicate: #Predicate { $0.rawPost?.id == id }
        )
        
        return try? container.mainContext.fetch(postFetch).first
    }
    
    public func getPostComments(postId: Int) async throws -> CommentListResponse {
        fatalError()
    }
}
