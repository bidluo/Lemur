import Foundation
import SwiftData

public actor CommentRepositoryLocal: ModelActor {
    
    nonisolated public let modelContainer: ModelContainer
    nonisolated public let modelExecutor: ModelExecutor
    
    init(container: ModelContainer) {
        self.modelContainer = container
        let context = ModelContext(container)
        modelExecutor = DefaultSerialModelExecutor(modelContext: context)
    }
    
    func getComments(postId: Int) -> [Comment] {
        let commentFetch = FetchDescriptor<Comment>(
            predicate: #Predicate { $0.post?.rawId == postId }
        )
        
        let comments = try? modelContext.fetch(commentFetch)
        return comments ?? []
    }
    
    func saveComments(comments: [CommentDetailResponse]) async -> [Comment] {
        let post = comments.first?.post
        guard let postId = post?.id else { return [] }
        
        var postFetch = FetchDescriptor<PostDetail>(
            predicate: #Predicate { $0.rawId == postId }
        )
        
        postFetch.fetchLimit = 1
        
        guard let localPost = try? modelContext.fetch(postFetch).first else { return [] }
        
        let mappedComments = await comments.asyncCompactMap { [weak self] comment -> Comment? in
            await self?.saveComment(post: localPost, comment: comment)
        }
        
        return mappedComments
    }
    
    func saveComment(post: PostDetail?, comment: CommentDetailResponse) async -> Comment? {
        guard let commentId = comment.comment?.id, let creatorId = comment.creator?.id else { return nil }
        
        // Upsert comment
        let localComment: Comment
        if let existingComment = getComment(id: commentId) {
            localComment = existingComment
            localComment.update(with: comment)
        } else if let newComment = Comment(remote: comment, idPrefix: "") {
            localComment = newComment
            modelContext.insert(newComment)
        } else {
            return nil
        }
        
        var localCreator: Person?
        var creatorFetch = FetchDescriptor<Person>(
            predicate: #Predicate { $0.rawId == creatorId }
        )
        
        creatorFetch.fetchLimit = 1
        if let fetchId = try? modelContext.fetchIdentifiers(creatorFetch).first,
           let existingCreator = modelContext.model(for: fetchId) as? Person {
            
            localCreator = existingCreator
            localCreator?.update(with: comment.creator)
        } else if let newCreator = Person(remote: comment.creator, idPrefix: "") {
            localCreator = newCreator
            modelContext.insert(newCreator)
        }
        
        if let localPost = post {
            localComment.post = localPost
        }
        localComment.creator = localCreator
        modelContext.insert(localComment)
        
        return localComment
    }
    
    func getComment(id: Int) -> Comment? {
        // TODO: Handle ID clash across sites
        var commentFetch = FetchDescriptor<Comment>(
            predicate: #Predicate { $0.rawId == id }
        )
        
        commentFetch.fetchLimit = 1
        commentFetch.includePendingChanges = true
        
        guard let fetchId = try? modelContext.fetchIdentifiers(commentFetch).first,
              let comment = modelContext.model(for: fetchId) as? Comment
        else {
            return nil
        }
        
        return comment
    }
}
