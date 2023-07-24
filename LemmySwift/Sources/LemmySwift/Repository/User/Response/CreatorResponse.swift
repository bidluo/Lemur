import Foundation
import SwiftData

public protocol CreatorResponse {
    var id: Int? { get }
    var name: String? { get }
    var banned: Bool? { get }
    var published: String? { get }
    var actorID: URL? { get }
    var local: Bool? { get }
    var deleted: Bool? { get }
    var admin: Bool? { get }
    var botAccount: Bool? { get }
    var instanceID: Int? { get }
    var displayName: String? { get }
    var avatar: String? { get }
    var bio: String? { get }
    var banner: String? { get }
}

public struct CreatorResponseRemote: CreatorResponse, Codable {
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

@Model
public class CreatorResponseLocal: CreatorResponse {
    public var id: Int?
    public var name: String?
    public var banned: Bool?
    public var published: String?
    public var actorID: URL?
    public var local: Bool?
    public var deleted: Bool?
    public var admin: Bool?
    public var botAccount: Bool?
    public var instanceID: Int?
    public var displayName: String?
    public var avatar: String?
    public var bio: String?
    public var banner: String?
    
    public init(remote: CreatorResponseRemote?) {
        self.id = remote?.id
        self.name = remote?.name
        self.banned = remote?.banned
        self.published = remote?.published
        self.actorID = remote?.actorID
        self.local = remote?.local
        self.deleted = remote?.deleted
        self.admin = remote?.admin
        self.botAccount = remote?.botAccount
        self.instanceID = remote?.instanceID
        self.displayName = remote?.displayName
        self.avatar = remote?.avatar
        self.bio = remote?.bio
        self.banner = remote?.banner
    }
}
