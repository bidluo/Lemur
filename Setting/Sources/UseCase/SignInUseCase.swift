import Foundation
import Common
import LemmySwift
import Factory

class SignInUseCase: UseCaseType {
    
    @Injected(\.authenticationRepository) private var repository: AuthenticationRepositoryType
    @Injected(\.keychain) private var keychain: KeychainType
    
    struct Input {
        public let baseUrl: URL?
        public let username: String?
        public let password: String?
    }
    
    typealias Result = Void
    
    enum Failure: LocalizedError {
        case invalidToken
        case noUsername, noPassword
        case invalidUrl
    }
    
    required init() {
    }
    
    func call(input: Input) async throws -> Result {
        guard let username = input.username else { throw Failure.noUsername }
        guard let password = input.password else { throw Failure.noPassword }
        guard let url = input.baseUrl else { throw Failure.invalidUrl }
        let request = SignInRequest(username: username, password: password)
        let result = try await repository.signIn(baseUrl: url , request: request)
        guard let token = result.token else { throw Failure.invalidToken }
        
        try keychain.save(token: token, for: url, username: username)
        try keychain.save(token: token, for: url, username: "active")
    }
}
