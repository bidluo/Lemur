import Foundation
import SwiftUI
import Common

struct SignInView: View {
    
    @State private var store: SignInStore = SignInStore()
    @State private var errorHandling = ErrorHandling()
    
    init() {
    }
    
    var body: some View {
        VStack {
            Text("Sign in")
            
            TextField(text: $store.username, label: { Text("Username or email") })
            TextField(text: $store.password, label: { Text("Password") })
            
            Button(action: {
                executing(action: store.submit, errorHandler: errorHandling)
            }, label: {
                Text("Sign in")
            })
            
        }
        .withErrorHandling(errorHandling: errorHandling)
    }
}
