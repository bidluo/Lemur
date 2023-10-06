import Foundation

public class AuthenticationRepositoryRemote: NetworkType {
    var urlSession: URLSession
    var asyncActor: AsyncDataTaskActor
    
    init(urlSession: URLSession, keychain: KeychainType) {
        self.urlSession = urlSession
        self.asyncActor = AsyncDataTaskActor(keychain: keychain)
    }
    
    func signIn(baseUrl: URL, request: SignInRequest) async throws -> SignInResponse {
        try await perform(baseUrl: baseUrl, http: AuthenticationSpec.signIn(request))
    }
}
