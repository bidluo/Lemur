import Foundation
import SwiftData

@Model
public class PostDetail {
    @Attribute(.unique) public let id: String
    public let rawId: Int
    
    @Relationship public var creator: Creator?
    @Relationship public var community: Community?
//    @Transient public var counts: PostCountsResponse?
    
    public var creatorBannedFromCommunity: Bool?
    public var subscribed: String?
    public var saved: Bool?
    public var read: Bool?
    public var creatorBlocked: Bool?
    public var unreadComments: Int?
    
    public var name: String?
    public var url: URL?
    public var body: String?
    public var removed: Bool?
    public var locked: Bool?
    public var published: Date?
    public var deleted: Bool?
    public var nsfw: Bool?
    public var thumbnailURL: URL?
    public var apID: String?
    public var local: Bool?
    public var languageID: Int?
    public var embedTitle: String?
    public var embedDescription: String?
    public var updated: Date?
    
    public var upvotes, downvotes, commentsCount, score: Int?
    public var newestCommentTimeNecro, newestCommentTime: Date?
    public var featuredCommunity, featuredLocal: Bool?
    public var hotRank, hotRankActive: Int?
    
    @Relationship(.cascade, inverse: \Comment.post) var comments: [Comment]? = []
    
    init?(remote: PostDetailResponse?, idPrefix: String) {
        guard let postId = remote?.post?.id else { return nil }
        self.id = "\(idPrefix)-\(postId)"
        self.rawId = postId
        
        update(with: remote)
    }
    
    func update(with remote: PostDetailResponse?) {
        self.creatorBannedFromCommunity = remote?.creatorBannedFromCommunity
        self.subscribed = remote?.subscribed
        self.saved = remote?.saved
        self.read = remote?.read
        self.creatorBlocked = remote?.creatorBlocked
        self.unreadComments = remote?.unreadComments
        
        // Post content fields
        self.name = remote?.post?.name
        self.url = remote?.post?.url
        self.body = remote?.post?.body
        self.removed = remote?.post?.removed
        self.locked = remote?.post?.locked
        self.published = remote?.post?.published
        self.deleted = remote?.post?.deleted
        self.nsfw = remote?.post?.nsfw
        self.thumbnailURL = remote?.post?.thumbnailURL
        self.apID = remote?.post?.apID
        self.local = remote?.post?.local
        self.languageID = remote?.post?.languageID
        self.featuredCommunity = remote?.counts?.featuredCommunity
        self.featuredLocal = remote?.counts?.featuredLocal
        self.embedTitle = remote?.post?.embedTitle
        self.embedDescription = remote?.post?.embedDescription
        self.updated = remote?.post?.updated
        self.upvotes = remote?.counts?.upvotes
        self.downvotes = remote?.counts?.downvotes
        self.score = remote?.counts?.score
        
        self.newestCommentTimeNecro = remote?.counts?.newestCommentTimeNecro
        self.newestCommentTime = remote?.counts?.newestCommentTime
        self.hotRank = remote?.counts?.hotRank
        self.hotRankActive = remote?.counts?.hotRankActive
        self.commentsCount = remote?.counts?.comments
    }
}
