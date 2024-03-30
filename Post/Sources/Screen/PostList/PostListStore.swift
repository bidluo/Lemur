import Foundation
import Common
import Observation

@Observable
class PostListStore {
    
    @ObservationIgnored
    @UseCaseStream private var useCase: GetPostListUseCase
    
    var rows: [PostSummary] = []
    var selectedSort: GetPostListUseCase.Sort = .hot
    var lastRowId: Int?
    var page: Int = 1
    
    private var siteUrl: URL?
    private var communityId: Int?
    private var needsLoad = true
    
    public let mainItems = GetPostListUseCase.Sort.mainItems
    public let commentItems = GetPostListUseCase.Sort.commentItems
    public let topItems = GetPostListUseCase.Sort.topItems
    
    init(siteUrl: URL? = nil, communityId: Int? = nil) {
        self.siteUrl = siteUrl
        self.communityId = communityId
    }
    
    func reload() async throws {
        needsLoad = true
        try await load(replacingAll: true)
    }
    
    func loadNextPage() async throws {
        needsLoad = true
        page += 1
        try await load()
    }
    
    func load(replacingAll: Bool = false) async throws {
        guard needsLoad == true else { return }
        defer {
            needsLoad = false
        }
        
        async let result = useCase.call(
            input: .init(
                siteUrl: siteUrl,
                communityId: communityId,
                sort: selectedSort,
                page: page
            )
        )
        
        for try await posts in await result {
            if replacingAll {
                rows = posts.posts
            } else {
                rows.append(contentsOf: posts.posts)
            }
            
            lastRowId = posts.posts.last?.id
        }
    }
}
