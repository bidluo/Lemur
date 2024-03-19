import Foundation
import Common
import Observation

@Observable
class CommentComposeStore {
    
    @ObservationIgnored @UseCase private var createUseCase: CreateCommentUseCase
    @ObservationIgnored @UseCase private var loggedInUsersUseCase: GetLoggedInUsersUseCase
    
    private var isSubmitting = false
    
    let siteUrl: URL
    let postId: Int
    let parentId: Int?
    
    var commentText: String = ""
    var postAsUsers: [GetLoggedInUsersUseCase.Result.LoggedInUser] = []
    var selectedUser: GetLoggedInUsersUseCase.Result.LoggedInUser?
    
    init(siteUrl: URL, postId: Int, parentId: Int?) {
        self.siteUrl = siteUrl
        self.postId = postId
        self.parentId = parentId
    }
    
    func load() async throws {
        postAsUsers = try await loggedInUsersUseCase.call(input: ()).loggedInUsers
        selectedUser = postAsUsers.first
    }
    
    func submit() async throws {
        if isSubmitting == false {
            let _ = try await createUseCase.call(
                input: .init(
                    siteUrl: siteUrl,
                    content: commentText,
                    postId: postId,
                    parentId: parentId
                )
            )
        }
    }
}
