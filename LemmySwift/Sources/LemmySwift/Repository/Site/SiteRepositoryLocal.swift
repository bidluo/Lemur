import Foundation
import SwiftData

public actor SiteRepositoryLocal: ModelActor {
    nonisolated public let modelContainer: ModelContainer
    nonisolated public let modelExecutor: ModelExecutor
    
    
    init(container: ModelContainer) {
        self.modelContainer = container
        let context = ModelContext(container)
        modelExecutor = DefaultSerialModelExecutor(modelContext: context)
    }
    
    func addSite(siteName: String, siteUrl: URL) {
        let site = Site(name: siteName, url: siteUrl, active: true)
        modelContext.insert(site)
    }
    
    func getSites(activeOnly: Bool) -> [Site] {
        let sites: [Site]
        if activeOnly {
            let siteFetch = FetchDescriptor<Site>(
                predicate: #Predicate { $0.active == true }
            )
            
            sites = (try? modelContext.fetch(siteFetch)) ?? []
        } else {
            let siteFetch = FetchDescriptor<Site>()
            sites = (try? modelContext.fetch(siteFetch)) ?? []
        }
        
        return sites
    }
    
    func getSiteUrls(activeOnly: Bool) async -> [URL] {
        return getSites(activeOnly: activeOnly).map { $0.url }
    }
}
