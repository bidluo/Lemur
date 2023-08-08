import Foundation

class SiteRepositoryRemote: NetworkType {
    var urlSession: URLSession
    var asyncActor: AsyncDataTaskActor
    
    init(urlSession: URLSession, keychain: KeychainType) {
        self.urlSession = urlSession
        self.asyncActor = AsyncDataTaskActor(keychain: keychain)
    }
    
    func querySite(url: URL) async throws -> SiteOverviewResponse {
        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        return try await perform(request: request, skipAuth: true)
    }
}
