import Foundation

public protocol AuthenticationRepositoryType {
    func signIn(request: SignInRequest) async throws -> SignInResponse
}

public class AuthenticationRepositoryMain: AuthenticationRepositoryType {
    
    private let remote: AuthenticationRepositoryRemote
    
    init(remote: AuthenticationRepositoryRemote) {
        self.remote = remote
    }
    
    public func signIn(request: SignInRequest) async throws -> SignInResponse {
        return try await remote.signIn(request: request)
    }
}
