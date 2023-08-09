import Foundation

public class UserRepositoryRemote: NetworkType {
    var urlSession: URLSession
    var asyncActor: AsyncDataTaskActor
    
    init(urlSession: URLSession, keychain: KeychainType) {
        self.urlSession = urlSession
        self.asyncActor = AsyncDataTaskActor(keychain: keychain)
    }
    
    func getPerson(baseUrl: URL, username: String) async throws -> PersonDetailResponse {
        return try await perform(baseUrl: baseUrl, http: UserSpec.user(username))
    }
}
