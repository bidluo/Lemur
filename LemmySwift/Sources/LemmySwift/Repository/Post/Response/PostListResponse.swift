import Foundation

struct PostListResponse: Decodable {
    var posts: [PostDetailResponse]?
}
