import Foundation
import LemmySwift
import Factory

public class GetLoggedInUsersUseCase: UseCaseType {
    
    @Injected(\.userRepository) private var userRepository: UserRepositoryType
    @Injected(\.userDefaults) private var userDefaults: UserDefaultsType
    
    public static let LOGGED_IN_USERS = "logged_in_users"
    
    public typealias Input = Void
    
    public struct Result {
        public let loggedInUsers: [LoggedInUser]
        
        public struct LoggedInUser {
            public let id: String
            public let name: String?
            public let siteName: String?
        }
    }
    
    public required init() {
    }
    
    @MainActor
    public func call(input: Input) async throws -> Result {
        let loggedInUsers = userDefaults.stringArray(forKey: Self.LOGGED_IN_USERS) ?? []
        let users = try await userRepository.getPeople(withIds: loggedInUsers).map { user in
            return Result.LoggedInUser(id: user.id, name: user.name, siteName: user.site?.name)
        }
        
        return Result(loggedInUsers: users)
    }
}
