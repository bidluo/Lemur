import Foundation

struct PostResponseRemote: Decodable {
    var postDetails: PostDetailResponse?
    var communityDetails: CommunityOverviewResponse?
    var moderators: [PersonResponse]?
    var crossPosts: [PostDetailResponse]?
    
    enum CodingKeys: String, CodingKey {
        case postDetails = "post_view"
        case communityDetails = "community_view"
        case moderators = "moderators"
        case crossPosts = "cross_posts"
    }
}
