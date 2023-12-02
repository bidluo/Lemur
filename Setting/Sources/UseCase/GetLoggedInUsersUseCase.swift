import Foundation
import Common
import LemmySwift
import Factory

class GetLoggedInUsersUseCase: UseCaseType {
    
    @Injected(\.userRepository) private var userRepository: UserRepositoryType
    @Injected(\.userDefaults) private var userDefaults: UserDefaultsType
    
    typealias Input = Void
    
    struct Result {
        
        let loggedInUsers: [LoggedInUser]
        
        struct LoggedInUser {
            let id: String
            let name: String?
            let siteName: String?
        }
    }
    
    required init() {
    }
    
    @MainActor
    func call(input: Input) async throws -> Result {
        let loggedInUsers = userDefaults.stringArray(forKey: SignInUseCase.LOGGED_IN_USERS) ?? []
        let users = try await userRepository.getPeople(withIds: loggedInUsers).map { user in
            return Result.LoggedInUser(id: user.id, name: user.name, siteName: user.site?.name)
        }
        
        return Result(loggedInUsers: users)
    }
}
