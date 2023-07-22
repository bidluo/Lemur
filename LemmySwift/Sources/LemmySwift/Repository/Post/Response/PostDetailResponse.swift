import Foundation

public struct PostDetailResponse: Decodable {
    public let post: PostContentResponse?
    public let creator: ModeratorDetailResponse?
    public let community: CommunityResponse?
    public let creatorBannedFromCommunity: Bool?
    public let counts: PostCountsResponse?
    public let subscribed: String?
    public let saved, read, creatorBlocked: Bool?
    public let unreadComments: Int?
    
    enum CodingKeys: String, CodingKey {
        case post, creator, community
        case creatorBannedFromCommunity = "creator_banned_from_community"
        case counts, subscribed, saved, read
        case creatorBlocked = "creator_blocked"
        case unreadComments = "unread_comments"
    }
}

public struct PostCountsResponse: Decodable {
    public let id, postID, comments, score: Int?
    public let upvotes, downvotes: Int?
    public let published, newestCommentTimeNecro, newestCommentTime: String?
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

public struct ModeratorDetailResponse: Codable {
    public let id: Int?
    public let name: String?
    public let avatar: URL?
    public let banned: Bool?
    public let published: String?
    public let actorID: String?
    public let bio: String?
    public let local, deleted, admin, botAccount: Bool?
    public let instanceID: Int?
    public let displayName: String?
    public let banner: String?
    public let matrixUserID: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, avatar, banned, published
        case actorID = "actor_id"
        case bio, local, deleted, admin
        case botAccount = "bot_account"
        case instanceID = "instance_id"
        case displayName = "display_name"
        case banner
        case matrixUserID = "matrix_user_id"
    }
}

public struct ModeratorResponse: Decodable {
    public let community: CommunityResponse?
    public let moderator: ModeratorDetailResponse?
}
