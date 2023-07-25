import Foundation
import SwiftData

public class PostRepositoryLocal {
    
    private let context: ModelContext?
    
    init(context: ModelContext?) {
        self.context = context
    }
    
    public func getPosts() async -> PostListLocal {
        let posts = try? context?.fetch(FetchDescriptor<PostDetailResponseLocal>())
        return PostListLocal(posts: posts)
    }
    
    public func savePosts(posts: [PostDetailResponseRemote]) async {
        // TODO: Figure out how to do batch when there's actually documentation
        posts.forEach { [weak context] post in
            guard let localPost = PostDetailResponseLocal(remote: post) else { return }
            context?.insert(object: localPost)
        }
        
        try? context?.save()
    }
    
    public func getPost(id: Int) async -> PostDetailResponse? {
        let postFetch = FetchDescriptor<PostDetailResponseLocal>(
            predicate: #Predicate { $0.rawPost?.id == id }
        )
        
        return try? context?.fetch(postFetch).first
    }
}
