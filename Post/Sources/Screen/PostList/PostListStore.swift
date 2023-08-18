import Foundation
import Common
import Observation

@Observable
class PostListStore {
    
    @ObservationIgnored
    @UseCaseStream private var useCase: GetPostListUseCase
    
    var rows: [PostSummary] = []
    var selectedSort: GetPostListUseCase.Sort = .hot
    
    private var siteUrl: URL?
    private var communityId: Int?
    private var needsLoad = true
    
    public var mainItems: [GetPostListUseCase.Sort] { return [.hot, .active, .old, .new] }
    public var commentItems: [GetPostListUseCase.Sort] { return [.mostComments, .newComments] }
    public var topItems: [GetPostListUseCase.Sort] {
        return [
            .topHour,
            .topSixHour,
            .topTwelveHour,
            .topDay,
            .topWeek,
            .topMonth,
            .topThreeMonths,
            .topSixMonths,
            .topNineMonths,
            .topYear,
            .topAll
        ]
    }
    
    init(siteUrl: URL? = nil, communityId: Int? = nil) {
        self.siteUrl = siteUrl
        self.communityId = communityId
    }
    
    func reload() async throws {
        needsLoad = true
        try await load()
    }
    
    func load() async throws {
        guard needsLoad == true else { return }
        defer {
            needsLoad = false
        }
        
        for try await posts in await useCase.call(input: .init(siteUrl: siteUrl, communityId: communityId, sort: selectedSort)) {
            rows = posts.posts
        }
    }
    
}
