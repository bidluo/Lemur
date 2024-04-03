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
            let comments = self.handleComments(postId: input.postId, comments: response)
            return Result(comments: comments)
        })
    }
    
    private func handleComments(postId: Int, comments: [Comment]) -> [CommentContent] {
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
                postId: postId,
                content: content,
                creatorName: creator?.name ?? "",
                creatorIsLocal: creator?.local ?? false,
                publishDate: comment.published,
                creatorHome: nil,
                score: comment.score,
                myScore: comment.myVote, 
                hasNextSibling: false,
                parentId: nil,
                children: []
            )
            
            let pathIds = path.split(separator: ".").compactMap { Int($0) }
            let parentId = pathIds.dropLast().last ?? 0
            if parentId != 0 {
                comment.parentId = parentId
            }
            
            commentsDict[comment.id] = comment
            
            var childrenForParent = childrenDict[parentId] ?? []
            childrenForParent.append(comment)
            
            childrenDict[parentId] = childrenForParent
        }
        
        func buildTree(_ id: Int, currentDepth: Int = 0, parentLinesToDraw: Int = 0) -> [CommentContent]? {
            guard let children = childrenDict[id] else { return nil }
            var result: [CommentContent] = []
            
            for (index, child) in children.enumerated() {
                var child = child
                child.hasNextSibling = index < children.count - 1
                
                var childLinesToDraw = parentLinesToDraw
                
                // If this child is the last one, clear the bit at current depth. For others, set it.
                if child.hasNextSibling {
                    childLinesToDraw |= 1 << currentDepth
                } else {
                    childLinesToDraw &= ~(1 << currentDepth)
                }
                
                child.linesToDraw = childLinesToDraw
                
                child.children = buildTree(child.id, currentDepth: currentDepth + 1, parentLinesToDraw: childLinesToDraw)
                result.append(child)
            }
            return result
        }
        
        return buildTree(0) ?? []
    }
}
