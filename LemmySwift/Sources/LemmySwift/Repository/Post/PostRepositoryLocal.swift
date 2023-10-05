import Foundation
import SwiftData

actor PostRepositoryLocal: ModelActor {
    nonisolated public let modelContainer: ModelContainer
    nonisolated public let modelExecutor: ModelExecutor
    
    
    init(container: ModelContainer) {
        self.modelContainer = container
        let context = ModelContext(container)
        modelExecutor = DefaultSerialModelExecutor(modelContext: context)
    }
    
    func getPosts() async -> [PostDetail]? {
        return try? modelContext.fetch(FetchDescriptor<PostDetail>())
    }
    
    func savePosts(siteUrl: URL, posts: [PostDetailResponse], storeLocally: Bool = true) -> [PostDetail] {
        var siteFetch = FetchDescriptor<Site>()
        
        siteFetch.includePendingChanges = true
        
        let sites = try? modelContext.fetch(siteFetch)
        
        // `FetchDescriptor` `#Predicate` doesn't work with URL
        guard let site = sites?.first(where: { $0.url == siteUrl })
        else {
            return []
        }
        
        return posts.compactMap { post -> PostDetail? in
            savePost(site: site, post: post)
        }
    }
    
    func savePost(siteUrl: URL, post: PostDetailResponse?, storeLocally: Bool = true) -> PostDetail? {
        var siteFetch = FetchDescriptor<Site>()
        
        siteFetch.includePendingChanges = true
        
        let sites = try? modelContext.fetch(siteFetch)
        
        // `FetchDescriptor` `#Predicate` doesn't work with URL
        guard let site = sites?.first(where: { $0.url == siteUrl })
        else {
            return nil
        }
        
        return self.savePost(site: site, post: post)
    }
    
    func savePost(site: Site, post: PostDetailResponse?, storeLocally: Bool = true) -> PostDetail? {
        guard let id = post?.post?.id else { return nil }
        
        // Without doing this accessing the model from main thread violates thread access
        let localPost: PostDetail
        if let existingPost = getPost(id: id) {
            localPost = existingPost
        } else if let newPost = PostDetail(remote: post, idPrefix: site.id) {
            localPost = newPost
            
            if storeLocally {
                modelContext.insert(newPost)
            }
        } else {
            return nil
        }
        
        localPost.update(with: post)
        localPost.community = Community(remote: post?.community, idPrefix: site.id)
        localPost.creator = Person(remote: post?.creator, idPrefix: site.id)
        localPost.site = site
        
        try? modelContext.save()
        
        return localPost
    }
    
    func getPost(id: Int) -> PostDetail? {
        var postFetch = FetchDescriptor<PostDetail>(
            predicate: #Predicate { $0.rawId == id }
        )
        
        postFetch.fetchLimit = 1
        postFetch.includePendingChanges = true
        
        guard let fetchId = try? modelContext.fetchIdentifiers(postFetch).first,
              let post = modelContext.model(for: fetchId) as? PostDetail
        else {
            return nil
        }
        
        return post
    }
}
