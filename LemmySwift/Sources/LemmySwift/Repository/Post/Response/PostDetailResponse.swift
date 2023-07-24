import Foundation
import MetaCodable
import SwiftData

public protocol PostDetailResponse {
    var post: (any PostContent)? { get }
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

public struct PostDetailResponseRemote: PostDetailResponse, Decodable {
    public var rawPost: PostContentRemote?
    public var rawCreator: CreatorResponseRemote?
    public var rawCommunity: CommunityResponseRemote?
    public var creatorBannedFromCommunity: Bool?
    public var counts: PostCountsResponse?
    public var subscribed: String?
    public var saved, read, creatorBlocked: Bool?
    public var unreadComments: Int?
    
    public var creator: (CreatorResponse)? { return rawCreator }
    
    public var post: (PostContent)? {
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
public class PostDetailResponseLocal: PostDetailResponse {
    @Attribute(.unique) public let postId: Int
    public var rawPost: PostContentLocal?
    public var rawCreator: CreatorResponseLocal?
    public var rawCommunity: CommunityResponseLocal?
    public var creatorBannedFromCommunity: Bool?
    @Transient public var counts: PostCountsResponse?
    public var subscribed: String?
    public var saved: Bool?
    public var read: Bool?
    public var creatorBlocked: Bool?
    public var unreadComments: Int?
    
    public var post: (PostContent)? { return rawPost }
    public var community: (CommunityResponse)? { return rawCommunity }
    public var creator: CreatorResponse? { return rawCreator }
    
    init?(remote: PostDetailResponseRemote?) {
        let post = PostContentLocal(remote: remote?.rawPost)
        guard let postId = post.id else { return nil }
        
        self.postId = postId
        self.rawPost = post
        self.rawCreator = CreatorResponseLocal(remote: remote?.rawCreator)
        self.rawCommunity = CommunityResponseLocal(remote: remote?.rawCommunity)
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

