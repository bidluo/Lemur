import Foundation
import SwiftData

public actor CommentRepositoryLocal {
    
    private let context: ModelContext?
    
    init(context: ModelContext?) {
        self.context = context
    }
    
    func getComments(postId: Int) async -> [CommentDetailResponseLocal] {
        let commentFetch = FetchDescriptor<CommentDetailResponseLocal>(
            predicate: #Predicate { $0.rawPost?.id == postId }
        )
        
        let comments = try? context?.fetch(commentFetch)
        return comments ?? []
    }
    
    func saveComments(comments: [CommentDetailResponseRemote]) async {
        let post = comments.first?.rawPost
        guard let postId = post?.id else { return }
        
        let postFetch = FetchDescriptor<PostDetailResponseLocal>(
            predicate: #Predicate { $0.postId == postId }
        )
        
        guard let localPost = try? context?.fetch(postFetch).first else { return }
        
        comments.forEach { comment in
            try? context?.transaction {
                guard let localComment = CommentDetailResponseLocal(remote: comment) else { return }
                
                let creatorId = comment.rawCreator?.id
                let creatorFetch = FetchDescriptor<CreatorResponseLocal>(
                    predicate: #Predicate { $0.id != nil && $0.id == creatorId }
                )
                var creator = try? context?.fetch(creatorFetch).first
                
                if creator == nil {
                    creator = CreatorResponseLocal(remote: comment.rawCreator)
                }
                
                localComment.rawPost = localPost.rawPost
                localComment.rawCreator = creator
                self.context?.insert(object: localComment)
            }
        }
    }
}
