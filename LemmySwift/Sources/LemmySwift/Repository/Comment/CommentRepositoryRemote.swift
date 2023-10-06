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
    
    func getComment(baseUrl: URL, commentId: Int) async throws -> CommentDetailResponse {
        return try await perform(baseUrl: baseUrl, http: CommentSpec.comment(commentId))
    }
    
    func voteComment(siteUrl: URL, request: CommentVoteRequest) async throws -> SingleCommentResponse {
        return try await perform(baseUrl: siteUrl, http: CommentSpec.vote(request))
    }
    
    func createComment(siteUrl: URL, request: CommentCreateRequest) async throws -> SingleCommentResponse {
        return try await perform(baseUrl: siteUrl, http: CommentSpec.create(request))
    }
}
