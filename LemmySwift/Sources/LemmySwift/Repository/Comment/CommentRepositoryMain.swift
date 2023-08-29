import Foundation

public protocol CommentRepositoryType {
    func getComments(baseUrl: URL, postId: Int, sort: CommentSort) async -> AsyncThrowingStream<[Comment], Error>
    func getComment(siteUrl: URL, commentId: Int, localOnly: Bool) async -> AsyncThrowingStream<Comment, Error>
    func voteComment(siteURL: URL, request: CommentVoteRequest) async throws -> Comment
}

actor CommentRepositoryMain: CommentRepositoryType, RepositoryType {
    
    private let remote: CommentRepositoryRemote
    private let local: CommentRepositoryLocal
    
    init(remote: CommentRepositoryRemote, local: CommentRepositoryLocal) {
        self.remote = remote
        self.local = local
    }
    
    func getComments(baseUrl: URL, postId: Int, sort: CommentSort) async -> AsyncThrowingStream<[Comment], Error> {
        return fetchFromSources { [weak self] in
            await self?.local.getComments(postId: postId)
        } remoteDataSource: { [weak self] in
            try await self?.remote.getComments(baseUrl: baseUrl, postId: postId,  sort: sort).comments
        } transform: { [weak local] localResponse, remoteResponse in
            if let _remoteResponse = remoteResponse {
                return await local?.saveComments(comments: _remoteResponse)
            }
            
            return localResponse ?? []
        }
    }
    
    func getComment(siteUrl: URL, commentId: Int, localOnly: Bool) async -> AsyncThrowingStream<Comment, Error> {
        return fetchFromSources { [weak self] in
            await self?.local.getComment(id: commentId)
        } remoteDataSource: { [weak self] in
            guard localOnly == false else { return Optional<CommentDetailResponse>(nil) }
            return try await self?.remote.getComment(baseUrl: siteUrl, commentId: commentId)
        } transform: { [weak local] localResponse, remoteResponse in
            if let _remote = remoteResponse {
                let mappedComment = await local?.saveComment(post: nil, comment: _remote)
                return mappedComment
            }
            
            return localResponse
        }
    }
    
    func voteComment(siteURL: URL, request: CommentVoteRequest) async throws -> Comment {
        let response = try await remote.voteComment(siteUrl: siteURL, request: request)
        
        guard let localPost = await local.saveComment(post: nil, comment: response.comment) else {
            throw NetworkFailure.invalidResponse
        }
        
        return localPost
    }
}
