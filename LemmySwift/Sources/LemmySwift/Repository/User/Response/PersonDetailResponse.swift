import Foundation

struct PersonDetailResponse: Decodable {
    let personView: PersonViewResponse?
    let comments: [CommentDetailResponseRemote]?
    let posts: [PostDetailResponse]?
    let moderates: [ModeratedCommunity]?
    
    enum CodingKeys: String, CodingKey {
        case personView = "person_view"
        case comments, posts, moderates
    }
}

struct ModeratedCommunity: Decodable {
    let community: CommunityResponseRemote?
    let moderator: PersonResponse?
}

struct PersonViewResponse: Decodable {
    let person: PersonResponse?
    let counts: PersonCountsResponse?
}
