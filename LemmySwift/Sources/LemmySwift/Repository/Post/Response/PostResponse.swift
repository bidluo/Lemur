import Foundation

public protocol PostResponse {
    var postDetails: (any PostDetailResponse)? { get }
    var communityDetails: CommunityOverviewResponse? { get }
    var moderators: [any CreatorResponse]? { get }
    var crossPosts: [any PostDetailResponse]? { get }
}

struct PostResponseRemote: PostResponse, Decodable {
    var rawPostDetails: PostDetailResponseRemote?
    var communityDetails: CommunityOverviewResponse?
    var rawModerators: [CreatorResponseRemote]?
    var rawCrossPosts: [PostDetailResponseRemote]?
    
    var moderators: [CreatorResponse]? {
        return rawModerators
    }
    
    var postDetails: (PostDetailResponse)? {
        return rawPostDetails
    }
    
    var crossPosts: [PostDetailResponse]? {
        return rawCrossPosts
    }
    
    enum CodingKeys: String, CodingKey {
        case rawPostDetails = "post_view"
        case communityDetails = "community_view"
        case rawModerators = "moderators"
        case rawCrossPosts = "cross_posts"
    }
}
