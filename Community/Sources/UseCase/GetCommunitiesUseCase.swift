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
        
        let communities = communitiesResponse.compactMap { community -> Result.Community? in
            guard let id = community.title else { return nil }
            
            return Result.Community(id: id)
        }
        
        return Result(communities: communities ?? [])
    }
}
