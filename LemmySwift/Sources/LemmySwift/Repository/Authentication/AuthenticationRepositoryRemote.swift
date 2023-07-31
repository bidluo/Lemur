import Foundation

public class AuthenticationRepositoryRemote: NetworkType {
    var urlSession: URLSession
    var domain: URL
    var asyncActor: AsyncDataTaskActor
    
    init(domain: URL, urlSession: URLSession, keychain: KeychainType) {
        self.domain = domain
        self.urlSession = urlSession
        self.asyncActor = AsyncDataTaskActor(keychain: keychain)
    }
    
    func signIn(request: SignInRequest) async throws -> SignInResponse {
        try await perform(http: AuthenticationSpec.signIn(request))
    }
}
