import Foundation

public protocol KeychainType {
    func save(token: String) throws
    func getToken() throws -> String
}
