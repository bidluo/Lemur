import Foundation
import SwiftData

@Model
public class Community {
    @Attribute(.unique) public let id: String
    public let rawId: Int
    
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
    public var updated: Date?
    
    public var subscribed: SubscribedResponse?
    public var subscriberCount: Int?
    public var postCount: Int?
    public var dailyActiveUserCount: Int?
    
    @Relationship(inverse: \PostDetail.community) private var posts: [PostDetail]?
    @Relationship var site: Site?
    
    @Transient public var siteUrl: URL? {
        return site?.url
    }
    
    init?(remote: CommunityOverviewResponse?, idPrefix: String) {
        guard let communityId = remote?.community?.id else { return nil }
        self.rawId = communityId
        self.id = "\(idPrefix)-\(communityId)"
        
        update(with: remote)
    }
    
    init?(remote: CommunityResponse?, idPrefix: String) {
        guard let communityId = remote?.id else { return nil }
        self.rawId = communityId
        self.id = "\(idPrefix)-\(communityId)"
        
        update(with: remote)
    }
    
    func update(with remote: CommunityOverviewResponse?) {
        update(with: remote?.community)
        self.subscribed = remote?.subscribed
        
        self.postCount = remote?.counts?.posts
        self.subscriberCount = remote?.counts?.subscribers
        self.dailyActiveUserCount = remote?.counts?.usersActiveDay
    }
    
    func update(with remote: CommunityResponse?) {
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
