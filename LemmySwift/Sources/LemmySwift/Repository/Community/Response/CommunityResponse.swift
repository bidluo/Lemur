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
    var updated: String? { get }
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
    public let updated: String?
    
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
public class CommunityResponseLocal: CommunityResponse {
    public var id: Int?
    public var name: String?
    public var title: String?
    public var communityDescription: String?
    public var removed: Bool?
    public var published: String?
    public var deleted: Bool?
    public var nsfw: Bool?
    public var actorID: String?
    public var local: Bool?
    public var hidden: Bool?
    public var postingRestrictedToMods: Bool?
    public var instanceID: Int?
    public var icon: URL?
    public var banner: URL?
    public var updated: String?
    
    public init(remote: CommunityResponseRemote?) {
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
