import Foundation

struct PersonCountsResponse: Decodable {
    let id, personId, postCount, postScore: Int?
    let commentCount, commentScore: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case personId = "person_id"
        case postCount = "post_count"
        case postScore = "post_score"
        case commentCount = "comment_count"
        case commentScore = "comment_score"
    }
}
