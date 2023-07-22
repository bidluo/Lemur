import Foundation

public struct CommentContentResponse: Decodable {
    public let id, creatorID, postID: Int?
    public let content: String?
    public let removed: Bool?
    public let published: String?
    public let deleted: Bool?
    public let apID: String?
    public let local: Bool?
    public let path: String?
    public let distinguished: Bool?
    public let languageID: Int?
    public let updated: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case creatorID = "creator_id"
        case postID = "post_id"
        case content, removed, published, deleted
        case apID = "ap_id"
        case local, path, distinguished
        case languageID = "language_id"
        case updated
    }
}
