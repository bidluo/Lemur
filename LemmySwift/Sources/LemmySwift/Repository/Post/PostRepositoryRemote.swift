import Foundation

public class PostRepositoryRemote: NetworkType {
    var urlSession: URLSession
    var domain: URL
    var asyncActor: AsyncDataTaskActor
    
    init(domain: URL, urlSession: URLSession, keychain: KeychainType) {
        self.domain = domain
        self.urlSession = urlSession
        self.asyncActor = AsyncDataTaskActor(keychain: keychain)
    }
    
    func getPosts(sort: PostSort) async throws -> PostListResponseRemote {
        return try await perform(http: PostSpec.posts(sort))
    }
    
    func getPost(id: Int) async throws -> PostResponseRemote {
        return try await perform(http: PostSpec.post(id))
    }
}
