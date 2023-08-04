import Foundation

struct PostContentResponse: Decodable {
    var id: Int?
    var name: String?
    var url: URL?
    var body: String?
    var creatorID: Int?
    var communityID: Int?
    var removed: Bool?
    var locked: Bool?
    var published: Date?
    var deleted: Bool?
    var nsfw: Bool?
    var thumbnailURL: URL?
    var apID: String?
    var local: Bool?
    var languageID: Int?
    var featuredCommunity: Bool?
    var featuredLocal: Bool?
    var embedTitle: String?
    var embedDescription: String?
    var updated: Date?
    
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
