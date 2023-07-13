import Foundation
import LemmySwift
import Common
import Factory

class GetCommunitiesUseCase: UseCaseType {
    @Injected(\.communityRepository) private var repository: CommunityRepositoryType
    
    typealias Input = Void
    
    struct Result {
        let communities: [Community]
        
        struct Community {
            let id: String
        }
    }
    
    required init() {
    }
    
    func call(input: Void) async throws -> Result {
        let communitiesResponse = try await repository.getCommunities()
        
        let communities = communitiesResponse.communities?.compactMap { community -> Result.Community? in
            guard let _community = community.community, let id = _community.title else { return nil }
            
            return Result.Community(id: id)
        }
        
        return Result(communities: communities ?? [])
    }
}
