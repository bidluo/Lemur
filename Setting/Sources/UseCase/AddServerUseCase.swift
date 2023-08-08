import Foundation
import Common
import LemmySwift
import Factory

class AddServerUseCase: UseCaseType {
    
    @Injected(\.siteRepository) private var repository: SiteRepositoryType
    
    struct Input {
        public let url: URL?
    }
    
    typealias Result = Void
    
    enum Failure: LocalizedError {
        case invalidUrl
        case invalidSite
    }
    
    required init() {
    }
    
    func call(input: Input) async throws -> Result {
        guard let url = input.url else { throw Failure.invalidUrl }
        let siteUrl = url.appending(path: "/site")
        let site = try await repository.querySite(url: siteUrl)
        guard let siteName = site.siteView?.site?.name else { throw Failure.invalidSite }
        
        await repository.addSite(siteName: siteName, siteUrl: url)
    }
}
