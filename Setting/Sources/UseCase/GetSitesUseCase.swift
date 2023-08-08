import Foundation
import Common
import LemmySwift
import Factory

class GetSitesUseCase: UseCaseType {
    
    @Injected(\.siteRepository) private var repository: SiteRepositoryType
    
    struct Input {
        public let activeOnly = false
    }
    
    struct Result {
        let sites: [Site]
        
        struct Site {
            let name: String
            let active: Bool
            let urlString: String
        }
    }
    
    required init() {
    }
    
    @MainActor
    func call(input: Input) async throws -> Result {
        let sites = await repository.getSites(activeOnly: false).map { site in
            return Result.Site(name: site.name, active: site.active, urlString: site.url.absoluteString)
        }
        return Result(sites: sites)
    }
}
