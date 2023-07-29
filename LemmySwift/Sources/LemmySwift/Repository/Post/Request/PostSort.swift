import Foundation

public enum PostSort: String {
    case hot = "Hot"
    case active = "Active"
    case old = "Old"
    case new = "New"
    
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
