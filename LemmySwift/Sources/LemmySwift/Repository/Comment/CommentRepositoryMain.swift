import Foundation

public protocol CommentRepositoryType {
    func getComments(postId: Int) -> AsyncThrowingStream<[CommentDetailResponse], Error>
}

public class CommentRepositoryMain: CommentRepositoryType, RepositoryType {
    
    private let remote: CommentRepositoryRemote
    private let local: CommentRepositoryLocal
    
    init(remote: CommentRepositoryRemote, local: CommentRepositoryLocal) {
        self.remote = remote
        self.local = local
    }
    
    public func getComments(postId: Int) -> AsyncThrowingStream<[CommentDetailResponse], Error> {
        return fetchFromSources { [weak self] in
            await self?.local.getComments(postId: postId)
        } remoteDataSource: { [weak self] in
            try await self?.remote.getComments(postId: postId).comments
        } transform: { [weak local] localResponse, remoteResponse in
            if let _remoteResponse = remoteResponse {
                await local?.saveComments(comments: _remoteResponse)
            }
            
            return (remoteResponse ?? localResponse) ?? []
        }
    }
}
