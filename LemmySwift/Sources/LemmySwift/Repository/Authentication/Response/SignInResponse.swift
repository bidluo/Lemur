import Foundation

public struct SignInResponse: Decodable {
    public let token: String?
    
    enum CodingKeys: String, CodingKey {
        case token = "jwt"
    }
}
