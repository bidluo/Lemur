import Foundation

public protocol SiteRepositoryType {
    func querySite(url: URL) async throws -> SiteOverviewResponse
    func getSites(activeOnly: Bool) async -> [Site]
    func getSiteUrls(activeOnly: Bool) async -> [URL]
    func addSite(siteName: String, siteUrl: URL) async
}

class SiteRepository: SiteRepositoryType {
    
    private let remote: SiteRepositoryRemote
    private let local: SiteRepositoryLocal
    
    init(remote: SiteRepositoryRemote, local: SiteRepositoryLocal) {
        self.remote = remote
        self.local = local
    }
    
    func querySite(url: URL) async throws -> SiteOverviewResponse {
        return try await remote.querySite(url: url)
    }
    
    func getSites(activeOnly: Bool) async -> [Site] {
        return await local.getSites(activeOnly: activeOnly)
    }
    
    // Caller likely to be on a background thread so needs to be done within ModelActor
    func getSiteUrls(activeOnly: Bool) async -> [URL] {
        return await local.getSiteUrls(activeOnly: activeOnly)
    }
    
    func addSite(siteName: String, siteUrl:URL) async {
        await local.addSite(siteName: siteName, siteUrl: siteUrl)
    }
}
