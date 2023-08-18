import Foundation
import SwiftData

actor CommunityRepositoryLocal: ModelActor {
    nonisolated public let executor: any ModelExecutor
    
    init(container: ModelContainer) {
        let context = ModelContext(container)
        executor = DefaultModelExecutor(context: context)
    }
    
    func mapCommunities(siteUrl: URL, communities: [CommunityOverviewResponse], saveLocally: Bool) -> [Community] {
        var siteFetch = FetchDescriptor<Site>()
        
        siteFetch.includePendingChanges = true
        
        let sites = try? context.fetch(siteFetch)
        
        // `FetchDescriptor` `#Predicate` doesn't work with URL
        guard let site = sites?.first(where: { $0.url == siteUrl })
        else {
            return []
        }
        
        return communities.compactMap { community -> Community? in
            guard let id = community.community?.id else { return nil }
            
            // Without doing this accessing the model from main thread violates thread access
            let localCommunity: Community
            if let existingCommunity = getCommunity(siteUrl: site.url, id: id) {
                localCommunity = existingCommunity
            } else if let newCommunity = Community(remote: community, idPrefix: site.id) {
                localCommunity = newCommunity
                if saveLocally {
                    context.insert(newCommunity)
                }
            } else {
                return nil
            }
            
            localCommunity.update(with: community)
            localCommunity.site = site
            
            try? context.save()
            
            return localCommunity
        }
    }
    
    func getCommunity(siteUrl: URL, id: Int) -> Community? {
        var communityFetch = FetchDescriptor<Community>(
            predicate: #Predicate { $0.rawId == id }
        )
        
        communityFetch.fetchLimit = 1
        communityFetch.includePendingChanges = true
        
        guard let fetchId = try? context.fetchIdentifiers(communityFetch).first,
              let community = context.model(for: fetchId) as? Community
        else {
            return nil
        }
        
        return community
    }
}
