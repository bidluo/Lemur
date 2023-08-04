import Foundation

struct CommentListResponse: Decodable {
    let comments: [CommentDetailResponseRemote]?
}
