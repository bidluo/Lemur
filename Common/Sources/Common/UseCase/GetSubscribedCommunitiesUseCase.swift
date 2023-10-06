import Foundation
import LemmySwift
import Factory

public class GetSubscribedCommunitiesUseCase: UseCaseStreamType {
    @Injected(\.communityRepository) private var repository: CommunityRepositoryType
    
    public typealias Input = Void
    
    public struct Result {
        public let communities: [String: [Community]]
        
        public struct Community: Hashable {
            public let id: Int
            public let name: String
            public let siteUrl: URL?
            public let icon: URL?
        }
    }
    
    public required init() {
    }
    
    public func call(input: Void) async -> AsyncThrowingStream<Result, Error> {
        let stream = await repository.getSubscribedCommunities()
        
        return await mapAsyncStream(stream) { result -> Result in
            var communities: [String: [Result.Community]] = [:]
            guard case let .loaded(dictionary, _) = result else { return Result(communities: [:]) }
            dictionary?.forEach { pair in
                let siteName = pair.key.name
                
                let communityList = pair.value.compactMap { community -> Result.Community? in
                    guard community.subscribed == .subscribed else { return nil }
                    return Result.Community(
                        id: community.rawId,
                        name: community.title ?? "",
                        siteUrl: community.siteUrl,
                        icon: community.icon
                    )
                }
                
                communities[siteName] = communityList
            }

            
            return Result(communities: communities)
        }
    }
}
