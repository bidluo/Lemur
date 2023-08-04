import Foundation

public protocol CommentRepositoryType {
    func getComments(postId: Int, sort: CommentSort) async -> AsyncThrowingStream<[Comment], Error>
}

public actor CommentRepositoryMain: CommentRepositoryType, RepositoryType {
    
    private let remote: CommentRepositoryRemote
    private let local: CommentRepositoryLocal
    
    init(remote: CommentRepositoryRemote, local: CommentRepositoryLocal) {
        self.remote = remote
        self.local = local
    }
    
    public func getComments(postId: Int, sort: CommentSort) async -> AsyncThrowingStream<[Comment], Error> {
        return fetchFromSources { [weak self] in
            await self?.local.getComments(postId: postId)
        } remoteDataSource: { [weak self] in
            try await self?.remote.getComments(postId: postId, sort: sort).comments
        } transform: { [weak local] localResponse, remoteResponse in
            if let _remoteResponse = remoteResponse {
                return await local?.saveComments(comments: _remoteResponse)
            }
            
            return localResponse ?? []
        }
    }
}
