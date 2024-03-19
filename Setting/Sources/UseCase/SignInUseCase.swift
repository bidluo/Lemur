import Foundation
import Common
import LemmySwift
import Factory

class SignInUseCase: UseCaseType {
    
    @Injected(\.authenticationRepository) private var repository: AuthenticationRepositoryType
    @Injected(\.userRepository) private var userRepository: UserRepositoryType
    @Injected(\.keychain) private var keychain: KeychainType
    @Injected(\.userDefaults) private var userDefaults: UserDefaultsType
    
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
    
    @MainActor
    func call(input: Input) async throws -> Result {
        guard let username = input.username else { throw Failure.noUsername }
        guard let password = input.password else { throw Failure.noPassword }
        guard let url = input.baseUrl else { throw Failure.invalidUrl }
        let request = SignInRequest(username: username, password: password)
        let result = try await repository.signIn(baseUrl: url , request: request)
        var loggedInUsers = Set(userDefaults.stringArray(forKey: GetLoggedInUsersUseCase.LOGGED_IN_USERS) ?? [])
        
        for try await user in await userRepository.getPerson(siteUrl: url, username: username) {
            loggedInUsers.insert(user.id)
        }
        
        guard let token = result.token else { throw Failure.invalidToken }
        
        userDefaults.setValue([String](loggedInUsers), forKey: GetLoggedInUsersUseCase.LOGGED_IN_USERS)
        try keychain.save(token: token, for: url, username: username)
        try keychain.save(token: token, for: url, username: "active")
    }
}
