import Foundation
import LemmySwift
import Factory

public class GetSitesUseCase: UseCaseType {
    
    @Injected(\.siteRepository) private var repository: SiteRepositoryType
    
    public struct Input {
        let activeOnly: Bool
        
        public init(activeOnly: Bool = false) {
            self.activeOnly = activeOnly
        }
    }
    
    public struct Result {
        public let sites: [Site]
        
        public struct Site {
            public let name: String
            public let active: Bool
            public let url: URL
        }
    }
    
    public required init() {
    }
    
    @MainActor
    public func call(input: Input) async throws -> Result {
        let sites = await repository.getSites(activeOnly: false).map { site in
            return Result.Site(name: site.name, active: site.active, url: site.url)
        }
        return Result(sites: sites)
    }
}
