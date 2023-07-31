import Foundation
import Common
import Observation

@Observable
class SignInStore {
    
    @ObservationIgnored
    @UseCase private var useCase: SignInUseCase
    
    var username: String = ""
    var password: String = ""
    
    init() {
    }
    
    func submit() async throws {
        // Validation? 10 min chars
        try await useCase.call(input: .init(username: username, password: password))
    }
}
