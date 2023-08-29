import Foundation
import Common
import LemmySwift
import Factory

class GetPostCommentsUseCase: UseCaseStreamType {
    @Injected(\.commentRepository) private var repository: CommentRepositoryType
    
    struct Input {
        public let baseUrl: URL
        public let postId: Int
        public let sort: Sort
    }
    
    struct Result {
        public let comments: [CommentContent]
    }
    
    typealias Sort = LemmySwift.CommentSort
    
    required init() {
    }
    
    func call(input: Input) async -> AsyncThrowingStream<Result, Error>  {
        let commentsResponse = await repository.getComments(baseUrl: input.baseUrl, postId: input.postId, sort: input.sort)
        
        return await mapAsyncStream(commentsResponse, transform: { response in
            let comments = self.handleComments(comments: response)
            return Result(comments: comments)
        })
    }
    
    private func handleComments(comments: [Comment]) -> [CommentContent] {
        // A dictionary that maps from parent id to a list of child comments.
        var childrenDict: [Int: [CommentContent]] = [:]
        
        var commentsDict: [Int: CommentContent] = [:]
        
        comments.forEach { comment in
            let commentId = comment.rawId
            guard
                let content = comment.content,
                let path = comment.path
            else { return }
            
            let creator = comment.creator
            
            var comment = CommentContent(
                id: commentId,
                content: content,
                creatorName: creator?.name ?? "",
                creatorIsLocal: creator?.local ?? false,
                publishDate: comment.published,
                creatorHome: nil,
                score: comment.score,
                myScore: comment.myVote, 
                parentId: nil,
                children: []
            )
            
            let pathIds = path.split(separator: ".").compactMap { Int($0) }
            let parentId = pathIds.dropLast().last ?? 0
            if parentId != 0 {
                comment.parentId = parentId
            }
            
            commentsDict[comment.id] = comment
            if childrenDict[parentId] == nil {
                childrenDict[parentId] = []
            }
            childrenDict[parentId]!.append(comment)
        }
        
        func buildTree(_ id: Int) -> [CommentContent]? {
            guard let children = childrenDict[id] else { return nil }
            var result: [CommentContent] = []
            for child in children {
                var child = child
                child.children = buildTree(child.id)
                result.append(child)
            }
            return result
        }
        
        return buildTree(0) ?? []
    }
}
