import Foundation
import Common
import LemmySwift
import Factory

class GetPostCommentsUseCase: UseCaseType {
    
    @Injected(\.postRepository) private var repository: PostRepositoryType
    
    struct Input {
        public let postId: Int
    }
    
    struct Result {
        public let comments: [CommentContent]
    }
    
    required init() {
    }
    
    func call(input: Input) async throws -> Result {
        let commentsResponse = try await repository.getPostComments(postId: input.postId).comments
        // A dictionary that maps from parent id to a list of child comments.
        var childrenDict: [Int: [CommentContent]] = [:]
        
        var commentsDict: [Int: CommentContent] = [:]
        
        commentsResponse?.forEach { commentResponse in
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
                creatorHome: creator?.actorID?.host(),
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
        
        return Result(comments: buildTree(0) ?? [])
    }

}
