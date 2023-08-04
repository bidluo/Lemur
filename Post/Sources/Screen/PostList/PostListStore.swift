import Foundation
import Common
import Observation

@Observable
class PostListStore {
    
    @ObservationIgnored
    @UseCaseStream private var useCase: GetPostListUseCase
    
    var rows: [PostSummary] = []
    var selectedSort: GetPostListUseCase.Sort = .hot
    
    private var needsLoad = true
    
    @ObservationIgnored public var mainItems: [GetPostListUseCase.Sort] { return [.hot, .active, .old, .new] }
    @ObservationIgnored public var commentItems: [GetPostListUseCase.Sort] { return [.mostComments, .newComments] }
    @ObservationIgnored public var topItems: [GetPostListUseCase.Sort] {
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
    
    init() {
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
        
        for try await posts in await useCase.call(input: .init(sort: selectedSort)) {
            rows = posts.posts
        }
    }
    
}
