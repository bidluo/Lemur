import Foundation
import SwiftUI

public protocol PostViewProvider {
    func listView(siteUrl: URL?, communityId: Int?) -> AnyView
    func listView() -> AnyView
}
