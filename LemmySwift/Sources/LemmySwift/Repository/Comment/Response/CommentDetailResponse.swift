import Foundation

struct CommentDetailResponse: Decodable {
    var comment: CommentContentResponse?
    var creator: PersonResponse?
    var post: PostContentResponse?
    var community: CommunityResponse?
    var counts: CommentCounts?
    var creatorBannedFromCommunity: Bool?
    var subscribed: SubscribedResponse?
    var saved, creatorBlocked: Bool?
    var myVote: Int?
    
    enum CodingKeys: String, CodingKey {
        case comment = "comment"
        case creator = "creator"
        case post = "post"
        case community = "community"
        case creatorBannedFromCommunity = "creator_banned_from_community"
        case subscribed, saved, counts
        case creatorBlocked = "creator_blocked"
        case myVote = "my_vote"
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
