import Foundation

public protocol CommentRepositoryType {
    func getComments(postId: Int, sort: CommentSort) async -> AsyncThrowingStream<[CommentDetailResponse], Error>
}

public actor CommentRepositoryMain: CommentRepositoryType, RepositoryType {
    
    private let remote: CommentRepositoryRemote
    private let local: CommentRepositoryLocal
    
    init(remote: CommentRepositoryRemote, local: CommentRepositoryLocal) {
        self.remote = remote
        self.local = local
    }
    
    public func getComments(postId: Int, sort: CommentSort) async -> AsyncThrowingStream<[CommentDetailResponse], Error> {
        return fetchFromSources { [weak self] in
            await self?.local.getComments(postId: postId)
        } remoteDataSource: { [weak self] in
            try await self?.remote.getComments(postId: postId, sort: sort).comments
        } transform: { [weak local] localResponse, remoteResponse in
            // TODO: Reenable comment saving when comment model is flattened
            // Causes crash when sorting do to upsert behaviour
            
//            if let _remoteResponse = remoteResponse {
//                await local?.saveComments(comments: _remoteResponse)
//            }
            
            return (remoteResponse ?? localResponse) ?? []
        }
    }
}
