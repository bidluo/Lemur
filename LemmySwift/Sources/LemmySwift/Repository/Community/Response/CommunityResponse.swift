import Foundation

public struct CommunityResponse: Decodable {
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
