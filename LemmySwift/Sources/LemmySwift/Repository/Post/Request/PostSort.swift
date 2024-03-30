import Foundation

public enum PostSort: String, Equatable {
    case hot = "Hot"
    case active = "Active"
    case old = "Old"
    case new = "New"
    case scaled = "Scaled"
    
    case mostComments = "MostComments"
    case newComments = "NewComments"
    
    case topHour = "TopHour"
    case topSixHour = "TopSixHour"
    case topTwelveHour = "TopTwelveHour"
    case topDay = "TopDay"
    case topWeek = "TopWeek"
    case topMonth = "TopMonth"
    case topThreeMonths = "TopThreeMonths"
    case topSixMonths = "TopSixMonths"
    case topNineMonths = "TopNineMonths"
    case topYear = "TopYear"
    case topAll = "TopAll"
}

extension PostSort {
    public static var mainItems: [Self] { return [.hot, .active, .old, .new, .scaled] }
    public static var commentItems: [Self] { return [.mostComments, .newComments] }
    public static var topItems: [Self] {
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
}
