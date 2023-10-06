import Foundation

public protocol AuthenticationRepositoryType {
    func signIn(baseUrl: URL, request: SignInRequest) async throws -> SignInResponse
}

public class AuthenticationRepositoryMain: AuthenticationRepositoryType {
    
    private let remote: AuthenticationRepositoryRemote
    
    init(remote: AuthenticationRepositoryRemote) {
        self.remote = remote
    }
    
    public func signIn(baseUrl: URL, request: SignInRequest) async throws -> SignInResponse {
        return try await remote.signIn(baseUrl: baseUrl, request: request)
    }
}
