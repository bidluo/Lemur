import Foundation
import SwiftData

public protocol PostDetailResponse {
    var post: (any PostContentResponse)? { get }
    var creator: (any CreatorResponse)? { get }
    var community: (any CommunityResponse)? { get }
    var creatorBannedFromCommunity: Bool? { get }
    var counts: PostCountsResponse? { get }
    var subscribed: String? { get }
    var saved: Bool? { get }
    var read: Bool? { get }
    var creatorBlocked: Bool? { get }
    var unreadComments: Int? { get }
}

struct PostDetailResponseRemote: PostDetailResponse, Decodable {
    var rawPost: PostContentResponseRemote?
    var rawCreator: CreatorResponseRemote?
    var rawCommunity: CommunityResponseRemote?
    var creatorBannedFromCommunity: Bool?
    var counts: PostCountsResponse?
    var subscribed: String?
    var saved, read, creatorBlocked: Bool?
    var unreadComments: Int?
    
    public var creator: (CreatorResponse)? { return rawCreator }
    
    public var post: (PostContentResponse)? {
        return rawPost
    }
    
    public var community: (CommunityResponse)? {
        return rawCommunity
    }
    
    enum CodingKeys: String, CodingKey {
        case rawPost = "post"
        case rawCommunity = "community"
        case rawCreator = "creator"
        case creatorBannedFromCommunity = "creator_banned_from_community"
        case counts, subscribed, saved, read
        case creatorBlocked = "creator_blocked"
        case unreadComments = "unread_comments"
    }
}

@Model
class PostDetailResponseLocal: PostDetailResponse {
    @Attribute(.unique) let postId: Int
    @Relationship(.cascade)  var rawPost: PostContentResponseLocal?
    @Relationship  var rawCreator: CreatorResponseLocal?
    @Relationship  var rawCommunity: CommunityResponseLocal?
    @Transient  var counts: PostCountsResponse?
    var creatorBannedFromCommunity: Bool?
    var subscribed: String?
    var saved: Bool?
    var read: Bool?
    var creatorBlocked: Bool?
    var unreadComments: Int?
    
    var post: (PostContentResponse)? { return rawPost }
    var community: (CommunityResponse)? { return rawCommunity }
    var creator: CreatorResponse? { return rawCreator }
    
    init?(remote: PostDetailResponseRemote?) {
        guard let postId = remote?.rawPost?.id else { return nil }
        let post = PostContentResponseLocal(remote: remote?.rawPost)
        
        self.postId = postId
        self.rawPost = post
        self.creatorBannedFromCommunity = remote?.creatorBannedFromCommunity
        self.counts = remote?.counts
        self.subscribed = remote?.subscribed
        self.saved = remote?.saved
        self.read = remote?.read
        self.creatorBlocked = remote?.creatorBlocked
        self.unreadComments = remote?.unreadComments
    }
}

public struct PostCountsResponse: Codable {
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

