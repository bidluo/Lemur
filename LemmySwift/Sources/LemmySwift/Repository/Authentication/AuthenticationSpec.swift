import Foundation

enum AuthenticationSpec: Spec {
    case signIn(SignInRequest)
    
    var method: HTTPMethod {
        switch self {
            case let .signIn(request): .post(JSON.encode(obj: request))
        }
    }
    
    var path: String {
        switch self {
            case .signIn(_): "user/login"
        }
    }
}

