import Foundation

struct CommentContent: Identifiable, Hashable, Equatable {
    let id: Int
    let content: String
    let creatorName: String
    let creatorIsLocal: Bool
    let publishDate: Date?
    let creatorHome: String?
    var score: Int?
    
    // Display purpose only
    var parentId: Int?
    var children: [CommentContent]?
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}
