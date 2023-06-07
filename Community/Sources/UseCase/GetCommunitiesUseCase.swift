import Foundation
import LemmySwift
import Common

class GetCommunitiesUseCase: UseCaseType {
    private let repository: CommunityRepositoryType
    
    typealias Input = Void
    
    struct Result {
        let communities: [Community]
        
        struct Community {
            let id: String
        }
    }
    
    required init(provider: RepositoryProviderType) {
        self.repository = provider.inject()
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
