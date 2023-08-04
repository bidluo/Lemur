import Foundation
import LemmySwift

struct PostSummary {
    let id: Int
    let title: String
    let thumbnail: URL?
    let body: String?
    var creatorId: Int?
    let creatorName: String?
    let creatorThumbnail: URL?
    var communityId: Int?
    let communityName: String?
    let communityThumbnail: URL?
    let score: String
    
    enum Failure: LocalizedError {
        case invalidCreatorId
        case invalidCommunityId
        case invalidPost
    }
    
    init(post: PostDetail?) throws {
        guard let _post = post else { throw Failure.invalidPost }
        
        let creator = _post.creator
        let community = _post.community
        
        self.id = _post.rawId
        self.title = _post.name ?? ""
        
        // TODO: Post might not have thumbnail, but could be URL (as in the case of imgur links).
        // Would have to check if link is a picture or not
        self.thumbnail = _post.thumbnailURL
        self.body = _post.body
        self.creatorId = creator?.rawId
        self.creatorName = creator?.name
        self.creatorThumbnail = creator?.avatar
        self.communityId = community?.rawId
        self.communityName = community?.name
        self.communityThumbnail = community?.icon
        self.score = post?.score?.formatted() ?? ""
    }
    
    init(
        id: Int,
        title: String,
        thumbnail: URL? = nil,
        body: String? = nil,
        creatorId: Int,
        creatorName: String,
        creatorThumbnail: URL? = nil,
        communityId: Int,
        communityName: String,
        communityThumbnail: URL? = nil,
        score: String
    ) {
        self.id = id
        self.title = title
        self.thumbnail = thumbnail
        self.body = body
        self.creatorId = creatorId
        self.creatorName = creatorName
        self.creatorThumbnail = creatorThumbnail
        self.communityId = communityId
        self.communityName = communityName
        self.communityThumbnail = communityThumbnail
        self.score = score
    }
}
