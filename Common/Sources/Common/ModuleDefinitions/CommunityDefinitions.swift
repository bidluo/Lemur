import Foundation
import SwiftUI

public protocol CommunityViewProvider {
    func listView() -> AnyView
}

