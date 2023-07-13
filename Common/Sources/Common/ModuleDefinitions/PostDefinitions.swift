import Foundation
import SwiftUI

public protocol PostViewProvider {
    func listView() -> AnyView
}
