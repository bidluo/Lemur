import Foundation

public struct CommentListResponse: Decodable {
    public let comments: [CommentDetailResponse]?
}
