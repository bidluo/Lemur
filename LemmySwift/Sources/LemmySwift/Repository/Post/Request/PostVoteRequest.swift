import Foundation

public struct PostVoteRequest: Encodable {
    let postId: Int
    let score: Int
    let auth: String
    
    public init(postId: Int, score: Int, auth: String) {
        self.postId = postId
        self.score = score
        self.auth = auth
    }
    
    enum CodingKeys: String, CodingKey {
        case postId = "post_id"
        case score
        case auth
    }
}
