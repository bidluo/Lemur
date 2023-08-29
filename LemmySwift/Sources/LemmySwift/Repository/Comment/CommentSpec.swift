import Foundation

enum CommentSpec: Spec {
    case comments(Int, CommentSort)
    case comment(Int)
    case vote(CommentVoteRequest)
    
    var method: HTTPMethod {
        switch self {
        case .comments(_, _): .get
        case .comment(_): .get
        case let .vote(request): .post(JSON.encode(obj: request))
        }
    }
    
    var path: String {
        switch self {
        case .comments(_, _): "comment/list"
        case .comment(_): "comment"
        case .vote(_): "comment/like"
        }
    }
    
    var query: [URLQueryItem] {
        switch self {
        case let .comments(postId, sort): [
            URLQueryItem(name: "post_id", value: String(postId)),
            URLQueryItem(name: "max_depth", value: String(8)),
            URLQueryItem(name: "sort", value: sort.rawValue),
        ]
        case let .comment(commentId): [
            URLQueryItem(name: "id", value: String(commentId))
        ]
        default: []
        }
    }
}

