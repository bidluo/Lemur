import Foundation

public class CommentRepositoryRemote: NetworkType {
    var urlSession: URLSession
    var domain: URL
    var asyncActor: AsyncDataTaskActor
    
    init(domain: URL, urlSession: URLSession, keychain: KeychainType) {
        self.domain = domain
        self.urlSession = urlSession
        self.asyncActor = AsyncDataTaskActor(keychain: keychain)
    }
    
    func getComments(postId: Int, sort: CommentSort) async throws -> CommentListResponse {
        return try await perform(http: CommentSpec.comments(postId, sort))
    }
}
