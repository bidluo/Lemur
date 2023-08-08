import Foundation
import SwiftData

public actor SiteRepositoryLocal: ModelActor {
    
    nonisolated public let executor: any ModelExecutor
    
    init(container: ModelContainer) {
        let context = ModelContext(container)
        executor = DefaultModelExecutor(context: context)
    }
    
    func addSite(siteName: String, siteUrl: URL) {
        let site = Site(name: siteName, url: siteUrl, active: true)
        context.insert(site)
    }
    
    func getSites(activeOnly: Bool) -> [Site] {
        let sites: [Site]
        if activeOnly {
            let siteFetch = FetchDescriptor<Site>(
                predicate: #Predicate { $0.active == true }
            )
            
            sites = (try? context.fetch(siteFetch)) ?? []
        } else {
            let siteFetch = FetchDescriptor<Site>()
            sites = (try? context.fetch(siteFetch)) ?? []
        }
        
        return sites
    }
    
    func getSiteUrls(activeOnly: Bool) async -> [URL] {
        return getSites(activeOnly: activeOnly).map { $0.url }
    }
}
