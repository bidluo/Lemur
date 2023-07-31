import Foundation
import SwiftUI

public protocol SettingsViewProvider {
    func mainSettingsView() -> AnyView
    func signInView() -> AnyView
}

