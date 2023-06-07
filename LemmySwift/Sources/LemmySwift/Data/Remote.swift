import Foundation

protocol Remote {
    var domain: URL { get set }
    func buildRequest(http: Spec) throws -> URLRequest
}

enum RemoteError: Error {
    case invalidInput
    case invalidURL
    case invalidPath
}

extension Remote {
    func buildRequest(http: Spec) throws -> URLRequest {
        guard http.path.isEmpty == false else {
            throw RemoteError.invalidInput
        }
        
        guard let sanitisedPath = http.path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            throw RemoteError.invalidPath
        }
        
        var components = URLComponents()
        components.scheme = domain.scheme
        components.host = domain.host
        components.path = sanitisedPath
        
        let queryItems = http.query.filter { $0.value != nil }
        if queryItems.isEmpty == false {
            components.queryItems = queryItems
        }
        
        guard let url = components.url else {
            throw RemoteError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = http.method.text
        request.httpBody = http.method.body
        
        if let contentType = http.contentType {
            request.addValue(contentType.rawValue, forHTTPHeaderField: ContentType.key)
        }
        
        return request
    }
}
