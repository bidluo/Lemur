import Foundation

enum PostSpec: Spec {
    case posts
    case post(Int)
    
    var method: HTTPMethod {
        switch self {
        case .posts: return .get
        case .post(_): return .get
        }
    }
    
    var path: String {
        switch self {
        case .posts: return "post/list"
        case .post(_): return "post"
        }
    }
    
    var query: [URLQueryItem] {
        switch self {
        case let .post(id): [URLQueryItem(name: "id", value: String(id))]
        default: []
        }
    }
}

