import Foundation
import SwiftUI
import Common

public class ViewProvider: SettingsViewProvider {
    public func mainSettingsView() -> AnyView {
        return AnyView(MainSettingsView())
    }
    
    public func signInView() -> AnyView {
        return AnyView(SignInView())
    }
    
    public init() {
        
    }
}
