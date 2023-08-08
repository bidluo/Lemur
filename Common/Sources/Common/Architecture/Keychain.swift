import Foundation
import LemmySwift

public enum KeychainFailure: LocalizedError {
    case saveFailure
    case readFailure
    case invalidUrl
}

class Keychain: KeychainType {
    
    init() {}
    
    func save(token: String, for url: URL, username: String) throws {
        guard let _url = url.host() else { throw KeychainFailure.invalidUrl }
        let data = Data(token.utf8)
        try self.save(data, service: _url, account: username)
    }
    
    func getToken(for request: URLRequest) throws -> String {
        guard let host = request.url?.host(), let data = self.read(service: host, account: "active")
        else { throw KeychainFailure.readFailure }
        
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
