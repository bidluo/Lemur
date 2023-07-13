import Foundation

enum PostSpec: Spec {
    case posts
    
    var method: HTTPMethod {
        switch self {
            case .posts: return .get
        }
    }
    
    var path: String {
        switch self {
            case .posts: return "post/list"
        }
    }
}

