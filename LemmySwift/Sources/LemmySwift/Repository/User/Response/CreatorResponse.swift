import Foundation

public struct CreatorResponse: Decodable {
    public let id: Int?
    public let name: String?
    public let banned: Bool?
    public let published: String?
    public let actorID: URL?
    public let local, deleted, admin, botAccount: Bool?
    public let instanceID: Int?
    public let displayName: String?
    public let avatar: String?
    public let bio: String?
    public let banner: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, banned, published
        case actorID = "actor_id"
        case local, deleted, admin
        case botAccount = "bot_account"
        case instanceID = "instance_id"
        case displayName = "display_name"
        case avatar, bio, banner
    }
}
