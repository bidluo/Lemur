import Foundation

struct CreatorResponseRemote: Decodable {
    let id: Int?
    let name: String?
    let banned: Bool?
    let published: String?
    let actorID: URL?
    let local, deleted, admin, botAccount: Bool?
    let instanceID: Int?
    let displayName: String?
    let avatar: URL?
    let bio: String?
    let banner: String?
    
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
