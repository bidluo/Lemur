import Foundation

public struct CommentDetailResponse: Decodable {
    public let comment: CommentContentResponse?
    public let creator: CreatorResponse?
    public let post: PostResponse?
    public let community: CommunityResponse?
    public let counts: CommentCounts?
    public let creatorBannedFromCommunity: Bool?
    public let subscribed: SubscribedResponse?
    public let saved, creatorBlocked: Bool?
    
    enum CodingKeys: String, CodingKey {
        case comment, creator, post, community, counts
        case creatorBannedFromCommunity = "creator_banned_from_community"
        case subscribed, saved
        case creatorBlocked = "creator_blocked"
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
