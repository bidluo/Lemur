import Foundation

struct CommentContent: Identifiable, Hashable, Equatable {
    let id: Int
    let postId: Int
    let content: String
    let creatorName: String
    let creatorIsLocal: Bool
    let publishDate: Date?
    let creatorHome: String?
    var score: Int?
    var myScore: Int?
    var hasNextSibling: Bool
    var linesToDraw: Int = 0 
    
    // Display purpose only
    var parentId: Int?
    var children: [CommentContent]?
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id &&
        lhs.postId == rhs.postId &&
        lhs.content == rhs.content &&
        lhs.creatorName == rhs.creatorName &&
        lhs.creatorIsLocal == rhs.creatorIsLocal &&
        lhs.publishDate == rhs.publishDate &&
        lhs.creatorHome == rhs.creatorHome &&
        lhs.score == rhs.score &&
        lhs.myScore == rhs.myScore &&
        lhs.hasNextSibling == rhs.hasNextSibling &&
        lhs.linesToDraw == rhs.linesToDraw
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(postId)
        hasher.combine(content)
        hasher.combine(creatorName)
        hasher.combine(creatorIsLocal)
        hasher.combine(publishDate)
        hasher.combine(creatorHome)
        hasher.combine(score)
        hasher.combine(myScore)
        hasher.combine(hasNextSibling)
        hasher.combine(linesToDraw)
    }
}
