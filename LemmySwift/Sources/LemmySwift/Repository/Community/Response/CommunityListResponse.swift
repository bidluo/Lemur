import Foundation
import SwiftData

public struct CommunityListResponse: Decodable {
    public let communities: [CommunityOverviewResponse]?
}

public struct CommunityOverviewResponse: Decodable {
    public let community: CommunityResponse?
    public let subscribed: SubscribedResponse?
    public let blocked: Bool?
    public let counts: CountsResponse?
}

// MARK: - Counts
public struct CountsResponse: Decodable {
    public let id, communityID, subscribers, posts: Int?
    public let comments: Int?
    public let published: String?
    public let usersActiveDay, usersActiveWeek, usersActiveMonth, usersActiveHalfYear: Int?
    public let hotRank: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case communityID = "community_id"
        case subscribers, posts, comments, published
        case usersActiveDay = "users_active_day"
        case usersActiveWeek = "users_active_week"
        case usersActiveMonth = "users_active_month"
        case usersActiveHalfYear = "users_active_half_year"
        case hotRank = "hot_rank"
    }
}

public enum SubscribedResponse: String, Codable {
    case notSubscribed = "NotSubscribed"
}
