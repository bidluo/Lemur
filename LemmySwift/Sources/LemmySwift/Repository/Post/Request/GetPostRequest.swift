import Foundation

public struct GetPostRequest {
    let sort: PostSort
    let page: Int
    let limit: Int = 20
    
    public init(sort: PostSort, page: Int) {
        self.sort = sort
        self.page = page
    }
}
