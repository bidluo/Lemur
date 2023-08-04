import Foundation

struct CommunityListResponse: Decodable {
    let communities: [CommunityOverviewResponse]?
}

struct CommunityOverviewResponse: Decodable {
    let community: CommunityResponseRemote?
    let subscribed: SubscribedResponse?
    let blocked: Bool?
    let counts: CommunityCountsResponse?
}

struct CommunityCountsResponse: Decodable {
    let id, communityID, subscribers, posts: Int?
    let comments: Int?
    let published: String?
    let usersActiveDay, usersActiveWeek, usersActiveMonth, usersActiveHalfYear: Int?
    let hotRank: Int?

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
