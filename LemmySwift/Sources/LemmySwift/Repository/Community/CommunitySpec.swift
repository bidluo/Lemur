import Foundation

enum CommunitySpec: Spec {
    case communities(PostSort)
    case subscribedCommunities
    
    var method: HTTPMethod {
        switch self {
        case .communities: return .get
        case .subscribedCommunities: return .get
        }
    }
    
    var path: String {
        switch self {
        case .communities, .subscribedCommunities: return "community/list"
        }
    }
    
    var query: [URLQueryItem] {
        switch self {
        case .communities(let sort): [
            URLQueryItem(name: "limit", value: "50"),
            URLQueryItem(name: "sort", value: sort.rawValue)
        ]
        case .subscribedCommunities: [URLQueryItem(name: "type", value: "Subscribed")]
        default: []
        }
    }
}

