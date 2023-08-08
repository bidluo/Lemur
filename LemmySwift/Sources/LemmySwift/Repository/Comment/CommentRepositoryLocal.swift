import Foundation
import SwiftData

public actor CommentRepositoryLocal: ModelActor {
    
    nonisolated public let executor: any ModelExecutor
    
    init(container: ModelContainer) {
        let context = ModelContext(container)
        executor = DefaultModelExecutor(context: context)
    }
    
    func getComments(postId: Int) -> [Comment] {
        let commentFetch = FetchDescriptor<Comment>(
            predicate: #Predicate { $0.post?.rawId == postId }
        )
        
        let comments = try? context.fetch(commentFetch)
        return comments ?? []
    }
    
    func saveComments(comments: [CommentDetailResponseRemote]) -> [Comment] {
        let post = comments.first?.post
        guard let postId = post?.id else { return [] }
        
        var postFetch = FetchDescriptor<PostDetail>(
            predicate: #Predicate { $0.rawId == postId }
        )
        
        postFetch.fetchLimit = 1
        
        guard let localPost = try? context.fetch(postFetch).first else { return [] }
        
        let mappedComments = comments.compactMap { comment -> Comment? in
            guard let commentId = comment.comment?.id, let creatorId = comment.creator?.id else { return nil }
            
            // Upsert comment
            let localComment: Comment
            if let existingComment = getComment(id: commentId) {
                localComment = existingComment
                localComment.update(with: comment)
            } else if let newComment = Comment(remote: comment, idPrefix: "") {
                localComment = newComment
                context.insert(newComment)
            } else {
                return nil
            }
            
            var localCreator: Person?
            var creatorFetch = FetchDescriptor<Person>(
                predicate: #Predicate { $0.rawId == creatorId }
            )
            
            creatorFetch.fetchLimit = 1
            if let fetchId = try? context.fetchIdentifiers(creatorFetch).first,
               let existingCreator = context.object(with: fetchId) as? Person {
                
                localCreator = existingCreator
                localCreator?.update(with: comment.creator)
            } else if let newCreator = Person(remote: comment.creator, idPrefix: "") {
                localCreator = newCreator
                context.insert(newCreator)
            }
            
            localComment.post = localPost
            localComment.creator = localCreator
            context.insert(localComment)
            
            return localComment
        }
        
        return mappedComments
    }
    
    func getComment(id: Int) -> Comment? {
        var commentFetch = FetchDescriptor<Comment>(
            predicate: #Predicate { $0.rawId == id }
        )
        
        commentFetch.fetchLimit = 1
        commentFetch.includePendingChanges = true
        
        guard let fetchId = try? context.fetchIdentifiers(commentFetch).first,
              let comment = context.object(with: fetchId) as? Comment
        else {
            return nil
        }
        
        return comment
    }
}
