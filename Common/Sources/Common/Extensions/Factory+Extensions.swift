import Foundation
import Factory
import LemmySwift

extension Container {
    
    var repositoryProvider: Factory<RepositoryProviderType> {
        Factory(self) { RepositoryProvider() }
    }
    
    var useCaseFactory: Factory<UseCaseFactoryType> {
        Factory(self) { UseCaseFactory() }
    }
    
}

public extension Container {
    var postRepository: Factory<PostRepositoryType> {
        Factory(self) { self.repositoryProvider().inject() }
    }
    
    var communityRepository: Factory<CommunityRepositoryType> {
        Factory(self) { self.repositoryProvider().inject() }
    }
}
