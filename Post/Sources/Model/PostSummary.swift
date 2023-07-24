import Foundation
import LemmySwift

struct PostSummary {

    let id: Int
    let title: String
    let thumbnail: URL?
    let body: String?
    let creatorId: Int
    let creatorName: String
    let creatorThumbnail: URL?
    let communityId: Int
    let communityName: String
    let communityThumbnail: URL?
    let score: String
    
    enum Failure: LocalizedError {
        case invalidCreatorId
        case invalidCommunityId
        case invalidPost
    }
    
    init(post: PostDetailResponse?) throws {
        guard let postContent = post?.post, let id = postContent.id else { throw Failure.invalidPost }
        
        let creator = post?.creator
        let community = post?.community
        
        guard let _creatorId = creator?.id else { throw Failure.invalidCreatorId }
        guard let _communityId = community?.id else { throw Failure.invalidCommunityId }
        
        self.id = id
        self.title = postContent.name ?? ""
        
        // TODO: Post might not have thumbnail, but could be URL (as in the case of imgur links).
        // Would have to check if link is a picture or not
        self.thumbnail = postContent.thumbnailURL
        self.body = postContent.body
        self.creatorId = _creatorId
        self.creatorName = creator?.name ?? ""
//        self.creatorThumbnail = creator?.avatar
        self.creatorThumbnail = nil
        self.communityId = _communityId
        self.communityName = community?.name ?? ""
        self.communityThumbnail = community?.icon
        self.score = post?.counts?.score?.formatted() ?? ""
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
