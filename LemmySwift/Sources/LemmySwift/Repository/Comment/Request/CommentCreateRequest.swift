import Foundation

public struct CommentCreateRequest: Encodable {
    public let content: String
    public let postId: Int
    public let parentId: Int?
    public let auth: String
    
    public init(content: String, postId: Int, parentId: Int?, auth: String) {
        self.content = content
        self.postId = postId
        self.parentId = parentId
        self.auth = auth
    }
    
    enum CodingKeys: String, CodingKey {
        case postId = "post_id"
        case parentId = "parent_id"
        case content
        case auth
    }
}
