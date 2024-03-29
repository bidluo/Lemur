import Foundation

public protocol KeychainType {
    func save(token: String, for: URL, username: String) throws
    func getToken(for: URL?) throws -> String
}
