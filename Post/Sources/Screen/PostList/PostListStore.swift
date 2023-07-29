import Foundation
import Common
import Observation

@Observable
class PostListStore {
    
    @ObservationIgnored
    @UseCaseStream private var useCase: GetPostListUseCase
    
    var rows: [PostSummary] = []
    var selectedSort: GetPostListUseCase.Sort = .hot
    
    
    @ObservationIgnored
    public var mainItems: [GetPostListUseCase.Sort] { return [.hot, .active, .old, .new] }
    
    @ObservationIgnored
    public var commentItems: [GetPostListUseCase.Sort] { return [.mostComments, .newComments] }
    
    @ObservationIgnored
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
    
    init() {
    }
    
    func load() async throws {
        for try await posts in await useCase.call(input: .init(sort: selectedSort)) {
            rows = posts.posts
        }
    }
}
