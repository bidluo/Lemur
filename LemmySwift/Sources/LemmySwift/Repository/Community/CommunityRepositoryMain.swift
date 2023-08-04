import Foundation

public protocol CommunityRepositoryType {
    func getCommunities() async throws -> [Community]
}

public class CommunityRepositoryMain: CommunityRepositoryType {
    
    private let remote: CommunityRepositoryRemote
    
    init(remote: CommunityRepositoryRemote) {
        self.remote = remote
    }
    
    public func getCommunities() async throws -> [Community] {
        return []
    }
}
