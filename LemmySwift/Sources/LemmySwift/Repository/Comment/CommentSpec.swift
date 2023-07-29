import Foundation

enum CommentSpec: Spec {
    case comments(Int, CommentSort)
    
    var method: HTTPMethod {
        switch self {
        case .comments(_, _): .get
        }
    }
    
    var path: String {
        switch self {
        case .comments(_, _): "comment/list"
        }
    }
    
    var query: [URLQueryItem] {
        switch self {
            case let .comments(postId, sort): [
                URLQueryItem(name: "post_id", value: String(postId)),
                URLQueryItem(name: "max_depth", value: String(8)),
                URLQueryItem(name: "sort", value: sort.rawValue),
            ]
        }
    }
}

