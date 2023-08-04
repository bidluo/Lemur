import Foundation

struct CommentContentResponseRemote: Decodable {
    var id: Int?
    var creatorID: Int?
    var postID: Int?
    var content: String?
    var removed: Bool?
    var published: Date?
    var deleted: Bool?
    var apID: String?
    var local: Bool?
    var path: String?
    var distinguished: Bool?
    var languageID: Int?
    var updated: Date?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case creatorID = "creator_id"
        case postID = "post_id"
        case content, removed, published, deleted
        case apID = "ap_id"
        case local, path, distinguished
        case languageID = "language_id"
        case updated
    }
}
