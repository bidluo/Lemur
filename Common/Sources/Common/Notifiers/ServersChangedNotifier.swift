import Foundation
import SwiftUI

@Observable
public class ServersChangedNotifier: ObservableObject {
    fileprivate var changeHash: UUID = UUID()
    
    public init() {}
    
    public func changed() {
        changeHash = UUID()
    }
}

struct ServerChangedNotifierModifer: ViewModifier {
    
    var notifier: ServersChangedNotifier
    var onChange: () -> ()
    
    func body(content: Content) -> some View {
        content.onChange(of: notifier.changeHash, { old, new in
            if old != new {
                onChange()
            }
        })
    }
}

public extension View {
    func serversChanged(
        notifier: ServersChangedNotifier,
        _ block: @escaping () -> ()
    ) -> some View {
        return self.modifier(
            ServerChangedNotifierModifer(
                notifier: notifier,
                onChange: block
            )
        )
    }
}
