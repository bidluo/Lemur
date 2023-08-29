import Foundation

public struct CommentVoteRequest: Encodable {
    let commentId: Int
    let score: Int
    let auth: String
    
    public init(commentId: Int, score: Int, auth: String) {
        self.commentId = commentId
        self.score = score
        self.auth = auth
    }
    
    enum CodingKeys: String, CodingKey {
        case commentId = "comment_id"
        case score
        case auth
    }
}
