import Foundation
import SwiftData

public protocol CommentDetailResponse {
    var comment: (any CommentContentResponse)? { get }
    var creator: (any CreatorResponse)? { get }
    var post: (any PostContentResponse)? { get }
    var community: (any CommunityResponse)? { get }
    var counts: CommentCounts? { get }
    var creatorBannedFromCommunity: Bool? { get }
    var subscribed: SubscribedResponse? { get }
    var saved: Bool? { get }
    var creatorBlocked: Bool? { get }
}

public struct CommentDetailResponseRemote: CommentDetailResponse, Decodable {
    public var rawComment: CommentContentResponseRemote?
    public var rawCreator: CreatorResponseRemote?
    public var rawPost: PostContentResponseRemote?
    public var rawCommunity: CommunityResponseRemote?
    public var counts: CommentCounts?
    public var creatorBannedFromCommunity: Bool?
    public var subscribed: SubscribedResponse?
    public var saved, creatorBlocked: Bool?
    
    public var comment: CommentContentResponse? { return rawComment }
    public var creator: CreatorResponse? { return rawCreator }
    public var post: PostContentResponse? { return rawPost }
    public var community: CommunityResponse? { return rawCommunity }
    
    enum CodingKeys: String, CodingKey {
        case rawComment = "comment"
        case rawCreator = "creator"
        case rawPost = "post"
        case rawCommunity = "community"
        case creatorBannedFromCommunity = "creator_banned_from_community"
        case subscribed, saved, counts
        case creatorBlocked = "creator_blocked"
    }
}

@Model
class CommentDetailResponseLocal: CommentDetailResponse {
    @Attribute(.unique) let commentId: Int
    @Relationship(.cascade) public var rawComment: CommentContentResponseLocal?
    @Relationship public var rawCreator: CreatorResponseLocal?
    @Relationship public var rawPost: PostContentResponseLocal?
    @Transient public var counts: CommentCounts?
    public var creatorBannedFromCommunity: Bool?
    @Transient public var subscribed: SubscribedResponse?
    public var saved: Bool?
    public var creatorBlocked: Bool?
    
    public var comment: (CommentContentResponse)? { return rawComment }
    public var creator: (CreatorResponse)? { return rawCreator }
    public var post: (PostContentResponse)? { return rawPost }
    public var community: (CommunityResponse)? { return nil }
    
    
    init?(remote: CommentDetailResponseRemote?) {
        guard let commentId = remote?.rawComment?.id else { return nil }
        let comment = CommentContentResponseLocal(remote: remote?.rawComment)
        
        self.commentId = commentId
        self.rawComment = comment
        self.counts = remote?.counts
        self.creatorBannedFromCommunity = remote?.creatorBannedFromCommunity
        self.subscribed = remote?.subscribed
        self.saved = remote?.saved
        self.creatorBlocked = remote?.creatorBlocked
    }
}

public struct CommentCounts: Decodable {
    public let id, commentID, score, upvotes: Int?
    public let downvotes: Int?
    public let published: Date?
    public let childCount, hotRank: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case commentID = "comment_id"
        case score, upvotes, downvotes, published
        case childCount = "child_count"
        case hotRank = "hot_rank"
    }
}
