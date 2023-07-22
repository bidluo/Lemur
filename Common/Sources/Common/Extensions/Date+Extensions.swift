import Foundation

extension Date {
    public var localisedOffset: String {
        return PrettyDateFormatter.shared.formatter.localizedString(for: self, relativeTo: Date())
    }
}

struct PrettyDateFormatter {
    static let shared = PrettyDateFormatter()
    
    let formatter: RelativeDateTimeFormatter
    
    init() {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        self.formatter = formatter
    }
}
