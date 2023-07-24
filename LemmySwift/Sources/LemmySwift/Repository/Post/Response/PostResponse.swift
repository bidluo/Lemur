import Foundation

public struct PostResponse: Decodable {
    public let postDetails: PostDetailResponse?
    public let communityDetails: CommunityOverviewResponse?
    public let moderators: [ModeratorResponse]?
    public let crossPosts: [PostDetailResponse]?
    
    enum CodingKeys: String, CodingKey {
        case postDetails = "post_view"
        case communityDetails = "community_view"
        case moderators
        case crossPosts = "cross_posts"
    }
}
