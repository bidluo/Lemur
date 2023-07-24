import Foundation

public protocol PostResponse {
    var postDetails: (any PostDetailResponse)? { get }
    var communityDetails: CommunityOverviewResponse? { get }
    var moderators: [any CreatorResponse]? { get }
    var crossPosts: [any PostDetailResponse]? { get }
}

public struct PostResponseRemote: PostResponse, Decodable {
    public var rawPostDetails: PostDetailResponseRemote?
    public var communityDetails: CommunityOverviewResponse?
    public var rawModerators: [CreatorResponseRemote]?
    public var rawCrossPosts: [PostDetailResponseRemote]?
    
    public var moderators: [CreatorResponse]? {
        return rawModerators
    }
    
    public var postDetails: (PostDetailResponse)? {
        return rawPostDetails
    }
    
    public var crossPosts: [PostDetailResponse]? {
        return rawCrossPosts
    }
    
    enum CodingKeys: String, CodingKey {
        case rawPostDetails = "post_view"
        case communityDetails = "community_view"
        case rawModerators = "moderators"
        case rawCrossPosts = "cross_posts"
    }
}
