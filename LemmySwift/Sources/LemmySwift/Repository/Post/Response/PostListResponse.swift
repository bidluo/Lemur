import Foundation
import SwiftData

public protocol PostListResponse {
    var posts: [any PostDetailResponse]? { get }
}

struct PostListResponseRemote: PostListResponse, Decodable {
    var posts: [PostDetailResponse]? {
        return rawPosts
    }
    
    var rawPosts: [PostDetailResponseRemote]?
    
    enum CodingKeys: String, CodingKey {
        case rawPosts = "posts"
    }
}

struct PostListResponseLocal: PostListResponse {
    var posts: [PostDetailResponse]? {
        return rawPosts
    }
    
    var rawPosts: [PostDetailResponseLocal]?
    
    init(posts: [PostDetailResponseLocal]? = nil) {
        self.rawPosts = posts
    }
}

