import Foundation

enum PostSpec: Spec {
    case posts
    case post(Int)
    case postComments(Int)
    
    var method: HTTPMethod {
        switch self {
        case .posts: .get
        case .post(_): .get
        case .postComments(_): .get
        }
    }
    
    var path: String {
        switch self {
        case .posts: "post/list"
        case .post(_): "post"
        case .postComments(_): "comment/list"
        }
    }
    
    var query: [URLQueryItem] {
        switch self {
        case let .post(id): [URLQueryItem(name: "id", value: String(id))]
        case let .postComments(postId): [
            URLQueryItem(name: "post_id", value: String(postId)),
            URLQueryItem(name: "max_depth", value: String(8)),
            URLQueryItem(name: "sort", value: "Hot"),
        ]
        default: []
        }
    }
}

