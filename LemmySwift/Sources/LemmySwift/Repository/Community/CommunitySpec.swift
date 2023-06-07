import Foundation

enum CommunitySpec: Spec {
    case communities
    
    var method: HTTPMethod {
        switch self {
        case .communities: return .get
        }
    }
    
    var path: String {
        switch self {
        case .communities: return "community/list"
        }
    }
}

