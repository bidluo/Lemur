import Foundation
import SwiftData

public protocol PostContentResponse {
    var id: Int? { get }
    var name: String? { get }
    var url: URL? { get }
    var body: String? { get }
    var creatorID: Int? { get }
    var communityID: Int? { get }
    var removed: Bool? { get }
    var locked: Bool? { get }
    var published: String? { get }
    var deleted: Bool? { get }
    var nsfw: Bool? { get }
    var thumbnailURL: URL? { get }
    var apID: String? { get }
    var local: Bool? { get }
    var languageID: Int? { get }
    var featuredCommunity: Bool? { get }
    var featuredLocal: Bool? { get }
    
    var embedTitle: String? { get }
    var embedDescription: String? { get }
    var updated: String? { get }
}

public struct PostContentResponseRemote: PostContentResponse, Decodable {
    public var id: Int?
    public var name: String?
    public var url: URL?
    public var body: String?
    public var creatorID: Int?
    public var communityID: Int?
    public var removed: Bool?
    public var locked: Bool?
    public var published: String?
    public var deleted: Bool?
    public var nsfw: Bool?
    public var thumbnailURL: URL?
    public var apID: String?
    public var local: Bool?
    public var languageID: Int?
    public var featuredCommunity: Bool?
    public var featuredLocal: Bool?
    public var embedTitle: String?
    public var embedDescription: String?
    public var updated: String?
    
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

@Model
class PostContentResponseLocal: PostContentResponse {
    public var id: Int?
    public var name: String?
    public var url: URL?
    public var body: String?
    public var creatorID: Int?
    public var communityID: Int?
    public var removed: Bool?
    public var locked: Bool?
    public var published: String?
    public var deleted: Bool?
    public var nsfw: Bool?
    public var thumbnailURL: URL?
    public var apID: String?
    public var local: Bool?
    public var languageID: Int?
    public var featuredCommunity: Bool?
    public var featuredLocal: Bool?
    public var embedTitle: String?
    public var embedDescription: String?
    public var updated: String?
    
    @Relationship(.cascade, inverse: \CommentDetailResponseLocal.rawPost) var comments: [CommentDetailResponseLocal]? = []
    
    init(remote: PostContentResponseRemote?) {
        self.id = remote?.id
        self.name = remote?.name
        self.url = remote?.url
        self.body = remote?.body
        self.creatorID = remote?.creatorID
        self.communityID = remote?.communityID
        self.removed = remote?.removed
        self.locked = remote?.locked
        self.published = remote?.published
        self.deleted = remote?.deleted
        self.nsfw = remote?.nsfw
        self.thumbnailURL = remote?.thumbnailURL
        self.apID = remote?.apID
        self.local = remote?.local
        self.languageID = remote?.languageID
        self.featuredCommunity = remote?.featuredCommunity
        self.featuredLocal = remote?.featuredLocal
        self.embedTitle = remote?.embedTitle
        self.embedDescription = remote?.embedDescription
        self.updated = remote?.updated
    }
}
