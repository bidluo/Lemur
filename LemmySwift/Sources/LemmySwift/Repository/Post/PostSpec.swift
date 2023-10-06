import Foundation

enum PostSpec: Spec {
    case posts(GetPostRequest)
    case communityPosts(Int, GetPostRequest)
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
        case let .posts(request): [
            URLQueryItem(name: "sort", value: request.sort.rawValue),
            URLQueryItem(name: "limit", value: "\(request.limit)"),
            URLQueryItem(name: "page", value: "\(request.page)")
        ]
        case let .communityPosts(communityId, request):
            [
                URLQueryItem(name: "sort", value: request.sort.rawValue),
                URLQueryItem(name: "community_id", value: String(communityId)),
                URLQueryItem(name: "limit", value: "\(request.limit)"),
                URLQueryItem(name: "page", value: "\(request.page)")
            ]
        default: []
        }
    }
}

