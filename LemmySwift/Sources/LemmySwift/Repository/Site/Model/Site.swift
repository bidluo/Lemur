import Foundation
import SwiftData

@Model
public class Site {
    
    @Attribute(.unique) public let id: String
    public let name: String
    public let url: URL
    public let active: Bool
    
    init(name: String, url: URL, active: Bool) {
        self.name = name
        self.url = url
        self.id = url.host() ?? url.absoluteString
        self.active = active
    }
}
