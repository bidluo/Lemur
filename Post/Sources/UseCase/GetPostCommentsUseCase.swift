import Foundation
import Common
import LemmySwift
import Factory

class GetPostCommentsUseCase: UseCaseStreamType {
    @Injected(\.commentRepository) private var repository: CommentRepositoryType
    
    struct Input {
        public let postId: Int
    }
    
    struct Result {
        public let comments: [CommentContent]
    }
    
    required init() {
    }
    
    func call(input: Input) -> AsyncThrowingStream<Result, Error>  {
        let commentsResponse = repository.getComments(postId: input.postId)
        
        return mapAsyncStream(commentsResponse, transform: { response in
            let comments = self.handleComments(comments: response)
            return Result(comments: comments)
        })
    }
    
    private func handleComments(comments: [CommentDetailResponse]) -> [CommentContent] {
        // A dictionary that maps from parent id to a list of child comments.
        var childrenDict: [Int: [CommentContent]] = [:]
        
        var commentsDict: [Int: CommentContent] = [:]
        
        comments.forEach { commentResponse in
            let commentContent = commentResponse.comment
            guard
                let commentId = commentContent?.id,
                let content = commentContent?.content,
                let path = commentContent?.path
            else { return }
            
            let creator = commentResponse.creator
            
            var comment = CommentContent(
                id: commentId,
                content: content,
                creatorName: creator?.name ?? "",
                creatorIsLocal: creator?.local ?? false,
                publishDate: commentResponse.counts?.published,
                creatorHome: nil,
                score: commentResponse.counts?.score,
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
