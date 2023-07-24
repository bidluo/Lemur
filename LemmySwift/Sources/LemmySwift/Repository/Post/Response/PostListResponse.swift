import Foundation

public struct PostListResponse: Decodable {
    public let posts: [PostDetailResponse]?
}

