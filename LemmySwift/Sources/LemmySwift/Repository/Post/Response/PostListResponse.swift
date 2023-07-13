import Foundation

public struct PostListResponse: Decodable {
    public let posts: [PostResponse]?
}

public struct PostResponse: Decodable {
    public let post: PostDetailsResponse?
    public let creator: CreatorResponse?
    public let community: CommunityResponse?
    public let creatorBannedFromCommunity: Bool?
    public let counts: CountsResponse?
    public let subscribed: SubscribedResponse?
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

public struct PostDetailsResponse: Decodable {
    public let id: Int?
    public let name: String?
    public let url: String?
    public let body: String?
    public let creatorID, communityID: Int?
    public let removed, locked: Bool?
    public let published: String?
    public let deleted, nsfw: Bool?
    public let thumbnailURL: String?
    public let apID: String?
    public let local: Bool?
    public let languageID: Int?
    public let featuredCommunity, featuredLocal: Bool?
    public let embedTitle, embedDescription: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, url, body
        case creatorID = "creator_id"
        case communityID = "community_id"
        case removed, locked, published, deleted, nsfw
        case thumbnailURL = "thumbnail_url"
        case apID = "ap_id"
        case local
        case languageID = "language_id"
        case featuredCommunity = "featured_community"
        case featuredLocal = "featured_local"
        case embedTitle = "embed_title"
        case embedDescription = "embed_description"
    }
}
