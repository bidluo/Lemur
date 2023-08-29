import Foundation

enum PostSpec: Spec {
    case posts(PostSort)
    case communityPosts(Int, PostSort)
    case post(Int)
    case vote(PostVoteRequest)
    
    var method: HTTPMethod {
        switch self {
        case .posts(_): .get
        case .communityPosts(_,_): .get
        case .post(_): .get
        case let .vote(request): .post(JSON.encode(obj: request))
        }
    }
    
    var path: String {
        switch self {
        case .posts(_): "post/list"
        case .communityPosts(_,_): "post/list"
        case .post(_): "post"
        case .vote(_): "post/like"
        }
    }
    
    var query: [URLQueryItem] {
        switch self {
        case let .post(id): [URLQueryItem(name: "id", value: String(id))]
        case let .posts(sort): [
            URLQueryItem(name: "sort", value: sort.rawValue),
        ]
        case let .communityPosts(communityId, sort):
            [
                URLQueryItem(name: "sort", value: sort.rawValue),
                URLQueryItem(name: "community_id", value: String(communityId))
            ]
        default: []
        }
    }
}

