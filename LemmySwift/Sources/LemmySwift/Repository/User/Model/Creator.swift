import Foundation
import SwiftData

@Model
public class Creator {
    @Attribute(.unique) public let id: String
    public let rawId: Int
    
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
    public var avatar: URL?
    public var bio: String?
    public var banner: String?
    
    @Relationship(inverse: \PostDetail.creator) var posts: [PostDetail]? = []
    @Relationship(inverse: \Comment.creator) var comments: [Comment]? = []
    
    init?(remote: CreatorResponseRemote?, idPrefix: String) {
        guard let creatorId = remote?.id else { return nil }
        
        self.id = "\(idPrefix)-\(creatorId)"
        self.rawId = creatorId
        
        update(with: remote)
    }
    
    func update(with remote: CreatorResponseRemote?) {
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
