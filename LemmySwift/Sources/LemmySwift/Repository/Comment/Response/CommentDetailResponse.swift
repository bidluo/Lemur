import Foundation

struct CommentDetailResponseRemote: Decodable {
    var comment: CommentContentResponseRemote?
    var creator: PersonResponse?
    var post: PostContentResponse?
    var community: CommunityResponseRemote?
    var counts: CommentCounts?
    var creatorBannedFromCommunity: Bool?
    var subscribed: SubscribedResponse?
    var saved, creatorBlocked: Bool?
    
    enum CodingKeys: String, CodingKey {
        case comment = "comment"
        case creator = "creator"
        case post = "post"
        case community = "community"
        case creatorBannedFromCommunity = "creator_banned_from_community"
        case subscribed, saved, counts
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
