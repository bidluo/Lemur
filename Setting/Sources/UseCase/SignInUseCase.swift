import Foundation
import Common
import LemmySwift
import Factory

class SignInUseCase: UseCaseType {
    
    @Injected(\.authenticationRepository) private var repository: AuthenticationRepositoryType
    @Injected(\.keychain) private var keychain: KeychainType
    
    struct Input {
        public let username: String
        public let password: String
    }
    
    typealias Result = Void
    
    enum Failure: LocalizedError {
        case invalidToken
    }
    
    required init() {
    }
    
    func call(input: Input) async throws -> Result {
        let request = SignInRequest(username: input.username, password: input.password)
        let result = try await repository.signIn(request: request)
        guard let token = result.token else { throw Failure.invalidToken }
        
        try keychain.save(token: token)
    }
}
