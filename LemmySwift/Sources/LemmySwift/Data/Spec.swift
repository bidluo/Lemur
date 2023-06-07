import Foundation

protocol Spec {
    var method: HTTPMethod { get }
    var path: String { get }
    var contentType: ContentType? { get }
    var query: [URLQueryItem] { get }
}

extension Spec {
    var contentType: ContentType? {
        return .json
    }

    var query: [URLQueryItem] {
        return []
    }
}

enum HTTPMethod {
    case get
    case post(_: Data?)
    case put(_: Data?)
    case patch(_: Data?)
    case delete

    var body: Data? {
        switch self {
        case .get: return nil
        case .post(let data): return data
        case .put(let data): return data
        case .patch(let data): return data
        case .delete: return nil
        }
    }

    var text: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        case .put: return "PUT"
        case .patch: return "PATCH"
        case .delete: return "DELETE"
        }
    }
}

