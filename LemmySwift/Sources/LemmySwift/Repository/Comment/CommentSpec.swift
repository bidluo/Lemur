import Foundation

enum CommentSpec: Spec {
    case comments(Int)
    
    var method: HTTPMethod {
        switch self {
        case .comments(_): .get
        }
    }
    
    var path: String {
        switch self {
        case .comments(_): "comment/list"
        }
    }
    
    var query: [URLQueryItem] {
        switch self {
        case let .comments(postId): [
            URLQueryItem(name: "post_id", value: String(postId)),
            URLQueryItem(name: "max_depth", value: String(8)),
            URLQueryItem(name: "sort", value: "Hot"),
        ]
        default: []
        }
    }
}

