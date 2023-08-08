import Foundation

public class CommentRepositoryRemote: NetworkType {
    var urlSession: URLSession
    var asyncActor: AsyncDataTaskActor
    
    init(urlSession: URLSession, keychain: KeychainType) {
        self.urlSession = urlSession
        self.asyncActor = AsyncDataTaskActor(keychain: keychain)
    }
    
    func getComments(baseUrl: URL, postId: Int, sort: CommentSort) async throws -> CommentListResponse {
        return try await perform(baseUrl: baseUrl, http: CommentSpec.comments(postId, sort))
    }
}
