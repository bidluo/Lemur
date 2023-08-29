import Foundation

struct SingleCommentResponse: Decodable {
    let comment: CommentDetailResponse
    
    enum CodingKeys: String, CodingKey {
        case comment = "comment_view"
    }
}
