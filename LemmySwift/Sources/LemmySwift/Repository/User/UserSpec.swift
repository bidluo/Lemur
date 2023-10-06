import Foundation

enum UserSpec: Spec {
    case user(String)
    
    var method: HTTPMethod {
        switch self {
        case .user(_): .get
        }
    }
    
    var path: String {
        switch self {
        case .user(_): "user"
        }
    }
    
    var query: [URLQueryItem] {
        switch self {
        case let .user(username): [
            URLQueryItem(name: "username", value: username)
        ]
        }
    }
}

