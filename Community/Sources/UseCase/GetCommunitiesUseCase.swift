import Foundation
import LemmySwift
import Common
import Factory

class GetCommunitiesUseCase: UseCaseType {
    @Injected(\.communityRepository) private var repository: CommunityRepositoryType
    
    struct Input {
        let siteUrl: URL
        let sort: Sort
    }
    
    typealias Sort = LemmySwift.PostSort
    
    struct Result {
        let communities: [Community]
        
        struct Community: Hashable {
            let id: Int
            let name: String
            let siteUrl: URL?
            let thumbnailUrl: URL?
            let description: String
            let postCount: Int
            let subsciberCount: Int
            let dailyActiveUserCount: Int
        }
    }
    
    required init() {
    }
    
    func call(input: Input) async throws -> Result {
        let communities = try await repository.getCommunities(siteUrl: input.siteUrl, sort: input.sort).map { item in
            return Result.Community(
                id: item.rawId,
                name: item.title ?? "",
                siteUrl: item.siteUrl,
                thumbnailUrl: item.icon,
                description: item.communityDescription ?? "",
                postCount: item.postCount ?? 0,
                subsciberCount: item.subscriberCount ?? 0,
                dailyActiveUserCount: item.dailyActiveUserCount ?? 0
            )
        }
        
        return Result(communities: communities)
    }
}
