import Foundation

public struct CommunityResponse: Decodable {
    public let id: Int?
    public let name, title, description: String?
    public let removed: Bool?
    public let published: String?
    public let deleted, nsfw: Bool?
    public let actorID: String?
    public let local, hidden, postingRestrictedToMods: Bool?
    public let instanceID: Int?
    public let icon, banner: String?
    public let updated: String?

    enum CodingKeys: String, CodingKey {
        case id, name, title, description, removed, published, deleted, nsfw
        case actorID = "actor_id"
        case local, hidden
        case postingRestrictedToMods = "posting_restricted_to_mods"
        case instanceID = "instance_id"
        case icon, banner, updated
    }
}