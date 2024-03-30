import Foundation
import SwiftUI

public struct AuthenticatedEnvironmentKey: EnvironmentKey {
    public static let defaultValue = false
}

public extension EnvironmentValues {
    var authenticated: Bool {
        get { self[AuthenticatedEnvironmentKey.self] }
        set { self[AuthenticatedEnvironmentKey.self] = newValue }
    }
}
