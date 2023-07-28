import Foundation
import SwiftData

public actor PostRepositoryLocal {
    
    private let context: ModelContext?
    
    init(context: ModelContext?) {
        self.context = context
    }
    
    func getPosts() async -> PostListResponseLocal {
        let posts = try? context?.fetch(FetchDescriptor<PostDetailResponseLocal>())
        return PostListResponseLocal(posts: posts)
    }
    
    func savePosts(posts: [PostDetailResponseRemote]) async {
        // TODO: Figure out how to do batch when there's actually documentation
        posts.forEach { post in
            try? context?.transaction {
                let communityId = post.rawCommunity?.id
                let creatorId = post.rawCreator?.id
                let communityFetch = FetchDescriptor<CommunityResponseLocal>(
                    predicate: #Predicate { $0.id != nil && $0.id == communityId }
                )
                
                let creatorFetch = FetchDescriptor<CreatorResponseLocal>(
                    predicate: #Predicate { $0.id != nil && $0.id == creatorId }
                )
                
                var community = try? context?.fetch(communityFetch).first
                var creator = try? context?.fetch(creatorFetch).first
                if community == nil {
                    community = CommunityResponseLocal(remote: post.rawCommunity)
                }
                
                if creator == nil {
                    creator = CreatorResponseLocal(remote: post.rawCreator)
                }
                
                guard let localPost = PostDetailResponseLocal(remote: post) else { return }
                localPost.rawCommunity = community
                localPost.rawCreator = creator
                self.context?.insert(object: localPost)
            }
        }
    }
    
    func getPost(id: Int) async -> PostDetailResponse? {
        let postFetch = FetchDescriptor<PostDetailResponseLocal>(
            predicate: #Predicate { $0.rawPost?.id == id }
        )
        
        return try? context?.fetch(postFetch).first
    }
}
