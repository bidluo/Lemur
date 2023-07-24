import Foundation
import SwiftData

public protocol PostList {
    var posts: [any PostDetailResponse]? { get }
}

public struct PostListRemote: PostList, Decodable {
    public var posts: [PostDetailResponse]? {
        return rawPosts
    }
    
    public var rawPosts: [PostDetailResponseRemote]?
    
    enum CodingKeys: String, CodingKey {
        case rawPosts = "posts"
    }
}

public struct PostListLocal: PostList {
    public var posts: [PostDetailResponse]? {
        return rawPosts
    }
    
    public var rawPosts: [PostDetailResponseLocal]?
    
    init(posts: [PostDetailResponseLocal]? = nil) {
        self.rawPosts = posts
    }
}

