import Foundation
import SwiftData

public protocol CommunityResponse {
    var id: Int? { get }
    var name: String? { get }
    var title: String? { get }
    var communityDescription: String? { get }
    var removed: Bool? { get }
    var published: String? { get }
    var deleted: Bool? { get }
    var nsfw: Bool? { get }
    var actorID: String? { get }
    var local: Bool? { get }
    var hidden: Bool? { get }
    var postingRestrictedToMods: Bool? { get }
    var instanceID: Int? { get }
    var icon: URL? { get }
    var banner: URL? { get }
    var updated: Date? { get }
}

public struct CommunityResponseRemote: CommunityResponse, Decodable {
    public let id: Int?
    public let name, title: String?
    public let communityDescription: String?
    public let removed: Bool?
    public let published: String?
    public let deleted, nsfw: Bool?
    public let actorID: String?
    public let local, hidden, postingRestrictedToMods: Bool?
    public let instanceID: Int?
    public let icon, banner: URL?
    public let updated: Date?
    
    enum CodingKeys: String, CodingKey {
        case communityDescription = "description"
        case id, name, title, removed, published, deleted, nsfw
        case actorID = "actor_id"
        case local, hidden
        case postingRestrictedToMods = "posting_restricted_to_mods"
        case instanceID = "instance_id"
        case icon, banner, updated
    }
}

@Model
class CommunityResponseLocal: CommunityResponse {
    @Attribute(.unique)  var id: Int?
    var name: String?
    var title: String?
    var communityDescription: String?
    var removed: Bool?
    var published: String?
    var deleted: Bool?
    var nsfw: Bool?
    var actorID: String?
    var local: Bool?
    var hidden: Bool?
    var postingRestrictedToMods: Bool?
    var instanceID: Int?
    var icon: URL?
    var banner: URL?
    var updated: Date?
    
    @Relationship(inverse: \PostDetailResponseLocal.rawCommunity)  var posts: [PostDetailResponseLocal]? = []
    
    init(remote: CommunityResponseRemote?) {
        self.id = remote?.id
        self.name = remote?.name
        self.title = remote?.title
        self.communityDescription = remote?.communityDescription
        self.removed = remote?.removed
        self.published = remote?.published
        self.deleted = remote?.deleted
        self.nsfw = remote?.nsfw
        self.actorID = remote?.actorID
        self.local = remote?.local
        self.hidden = remote?.hidden
        self.postingRestrictedToMods = remote?.postingRestrictedToMods
        self.instanceID = remote?.instanceID
        self.icon = remote?.icon
        self.banner = remote?.banner
        self.updated = remote?.updated
    }
}
