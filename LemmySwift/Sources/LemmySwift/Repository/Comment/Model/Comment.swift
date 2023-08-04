import Foundation
import SwiftData

@Model
public class Comment {
    @Attribute(.unique) public let id: String
    public let rawId: Int
    
    @Relationship public var creator: Creator?
    @Relationship public var post: PostDetail?
    public var creatorBannedFromCommunity: Bool?
    public var saved: Bool?
    public var creatorBlocked: Bool?
    
    public var creatorID: Int?
    public var postID: Int?
    public var content: String?
    public var removed: Bool?
    public var published: Date?
    public var deleted: Bool?
    public var apID: String?
    public var local: Bool?
    public var path: String?
    public var distinguished: Bool?
    public var languageID: Int?
    public var updated: Date?
    public var score, upvotes, downvotes: Int?
    public var childCount, hotRank: Int?
    
    init?(remote: CommentDetailResponseRemote?, idPrefix: String) {
        guard let commentId = remote?.comment?.id else { return nil }
        self.id = "\(idPrefix)-\(commentId)"
        self.rawId = commentId
        
        self.update(with: remote)
    }
    
    func update(with remote: CommentDetailResponseRemote?) {
        self.creatorBannedFromCommunity = remote?.creatorBannedFromCommunity
        self.saved = remote?.saved
        self.creatorBlocked = remote?.creatorBlocked
        
        self.creatorID = remote?.comment?.creatorID
        self.postID = remote?.comment?.postID
        self.content = remote?.comment?.content
        self.removed = remote?.comment?.removed
        self.published = remote?.comment?.published
        self.deleted = remote?.comment?.deleted
        self.apID = remote?.comment?.apID
        self.local = remote?.comment?.local
        self.path = remote?.comment?.path
        self.distinguished = remote?.comment?.distinguished
        self.languageID = remote?.comment?.languageID
        self.updated = remote?.comment?.updated
        self.upvotes = remote?.counts?.upvotes
        self.downvotes = remote?.counts?.downvotes
        self.score = remote?.counts?.score
    }
}
