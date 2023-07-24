import Foundation

public struct PostContentResponse: Decodable {
    public let id: Int?
    public let name: String?
    public let url: URL?
    public let body: String?
    public let creatorID, communityID: Int?
    public let removed, locked: Bool?
    public let published: String?
    public let deleted, nsfw: Bool?
    public let thumbnailURL: URL?
    public let apID: String?
    public let local: Bool?
    public let languageID: Int?
    public let featuredCommunity, featuredLocal: Bool?
    
    public let embedTitle, embedDescription: String?
    public let updated: String?
    
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
        case updated
    }
}
