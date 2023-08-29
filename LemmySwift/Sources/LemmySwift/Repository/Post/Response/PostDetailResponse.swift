import Foundation
import SwiftData

struct PostDetailResponse: Decodable {
    var post: PostContentResponse?
    var creator: PersonResponse?
    var community: CommunityResponse?
    var creatorBannedFromCommunity: Bool?
    var counts: PostCountsResponse?
    var subscribed: String?
    var saved, read, creatorBlocked: Bool?
    var unreadComments: Int?
    var myVote: Int?
    
    enum CodingKeys: String, CodingKey {
        case post = "post"
        case community = "community"
        case creator = "creator"
        case creatorBannedFromCommunity = "creator_banned_from_community"
        case counts, subscribed, saved, read
        case creatorBlocked = "creator_blocked"
        case unreadComments = "unread_comments"
        case myVote = "my_vote"
    }
}

public struct PostCountsResponse: Codable {
    public let id, postID, comments, score: Int?
    public let upvotes, downvotes: Int?
    public let published, newestCommentTimeNecro, newestCommentTime: Date?
    public let featuredCommunity, featuredLocal: Bool?
    public let hotRank, hotRankActive: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case postID = "post_id"
        case comments, score, upvotes, downvotes, published
        case newestCommentTimeNecro = "newest_comment_time_necro"
        case newestCommentTime = "newest_comment_time"
        case featuredCommunity = "featured_community"
        case featuredLocal = "featured_local"
        case hotRank = "hot_rank"
        case hotRankActive = "hot_rank_active"
    }
}

