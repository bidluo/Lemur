import Foundation

struct CommentListResponse: Decodable {
    let comments: [CommentDetailResponse]?
}
