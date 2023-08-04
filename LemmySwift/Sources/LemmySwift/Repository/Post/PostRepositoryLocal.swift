import Foundation
import SwiftData

public actor PostRepositoryLocal: ModelActor {
    nonisolated public let executor: any ModelExecutor
    
    init(container: ModelContainer) {
        let context = ModelContext(container)
        executor = DefaultModelExecutor(context: context)
    }
    
    func getPosts() async -> [PostDetail]? {
        return try? context.fetch(FetchDescriptor<PostDetail>())
    }
    
    func savePosts(posts: [PostDetailResponse]) -> [PostDetail] {
        return posts.compactMap { post -> PostDetail? in
            guard let id = post.post?.id else { return nil }
            
            // Without doing this accessing the model from main thread violates thread access
            let localPost: PostDetail
            if let existingPost = getPost(id: id) {
                existingPost.update(with: post)
                localPost = existingPost
            } else if let newPost = PostDetail(remote: post, idPrefix: "") {
                localPost = newPost
                newPost.update(with: post)
                context.insert(newPost)
            } else {
                return nil
            }
            
            localPost.community = Community(remote: post.community, idPrefix: "")
            localPost.creator = Creator(remote: post.creator, idPrefix: "")
            
            try? context.save()
            
            return localPost
        }
    }
    
    func getPost(id: Int) -> PostDetail? {
        var postFetch = FetchDescriptor<PostDetail>(
            predicate: #Predicate { $0.rawId == id }
        )
        
        postFetch.fetchLimit = 1
        postFetch.includePendingChanges = true
        
        guard let fetchId = try? context.fetchIdentifiers(postFetch).first,
              let post = context.object(with: fetchId) as? PostDetail
        else {
            return nil
        }
        
        return post
    }
}
