import Foundation
import SwiftData

public protocol CommentContentResponse {
    var id: Int? { get }
    var creatorID: Int? { get }
    var postID: Int? { get }
    var content: String? { get }
    var removed: Bool? { get }
    var published: Date? { get }
    var deleted: Bool? { get }
    var apID: String? { get }
    var local: Bool? { get }
    var path: String? { get }
    var distinguished: Bool? { get }
    var languageID: Int? { get }
    var updated: Date? { get }
}

public struct CommentContentResponseRemote: CommentContentResponse, Decodable {
    public var id: Int?
    public var creatorID: Int?
    public var postID: Int?
    public var content: String?
    public var removed: Bool?
    public var published: Date?
    public var deleted: Bool?
    public var apID: String?
    public var local: Bool?
    public var path: String?
    public var distinguished: Bool?
    public var languageID: Int?
    public var updated: Date?
    
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

@Model
public class CommentContentResponseLocal: CommentContentResponse {
    @Attribute(.unique) public var id: Int?
    public var creatorID: Int?
    public var postID: Int?
    public var content: String?
    public var removed: Bool?
    public var published: Date?
    public var deleted: Bool?
    public var apID: String?
    public var local: Bool?
    public var path: String?
    public var distinguished: Bool?
    public var languageID: Int?
    public var updated: Date?
    
    init(remote: CommentContentResponseRemote?) {
        self.id = remote?.id
        self.creatorID = remote?.creatorID
        self.postID = remote?.postID
        self.content = remote?.content
        self.removed = remote?.removed
        self.published = remote?.published
        self.deleted = remote?.deleted
        self.apID = remote?.apID
        self.local = remote?.local
        self.path = remote?.path
        self.distinguished = remote?.distinguished
        self.languageID = remote?.languageID
        self.updated = remote?.updated
    }
}
