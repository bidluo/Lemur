import Foundation
import LemmySwift

public enum KeychainFailure: LocalizedError {
    case saveFailure
    case readFailure
}

class Keychain: KeychainType {
    
    init() {}
    
    private static let TOKEN_SERVICE = "token"
    
    func save(token: String) throws {
        let data = Data(token.utf8)
        // TODO: Handle different servers
        try self.save(data, service: Self.TOKEN_SERVICE, account: "")
    }
    
    func getToken() throws -> String {
        guard let data = self.read(service: Self.TOKEN_SERVICE, account: "") else { throw KeychainFailure.readFailure }
        
        let accessToken = String(data: data, encoding: .utf8)
        return accessToken ?? ""
    }
    
    private func save(_ data: Data, service: String, account: String) throws {
        let query = [
            kSecValueData: data,
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
        ] as CFDictionary
        
        let status = SecItemAdd(query, nil)
        
        if status != errSecSuccess {
            throw KeychainFailure.saveFailure
        }
    }
    
    private func read(service: String, account: String) -> Data? {
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary
        
        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        
        return (result as? Data)
    }
}
