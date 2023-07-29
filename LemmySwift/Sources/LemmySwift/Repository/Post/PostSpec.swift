import Foundation

enum PostSpec: Spec {
    case posts(PostSort)
    case post(Int)
    
    var method: HTTPMethod {
        switch self {
        case .posts(_): .get
        case .post(_): .get
        }
    }
    
    var path: String {
        switch self {
        case .posts(_): "post/list"
        case .post(_): "post"
        }
    }
    
    var query: [URLQueryItem] {
        switch self {
            case let .post(id): [URLQueryItem(name: "id", value: String(id))]
            case let .posts(sort): [
                URLQueryItem(name: "sort", value: sort.rawValue),
            ]
        }
    }
}

