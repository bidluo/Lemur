import Foundation
import SwiftUI
import Common

struct SignInView: View {
    
    @State private var store: SignInStore = SignInStore()
    @State private var errorHandling = ErrorHandling()
    
    init() {
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Sign in")
            
            if store.loaded, store.sites.isEmpty == false {
                Menu(content: {
                    ForEach(store.sites, id: \.urlString) { site in
                        Button(action: {
                            store.userSiteUrlString = site.urlString
                            store.shouldShowAddServerField = false
                            store.siteSelectorDisplay = site.name
                        }, label: {
                            Text(site.name)
                            Text(site.urlString)
                        })
                    }
                    
                    Button(action: {
                        store.userSiteUrlString = ""
                        store.siteSelectorDisplay = "New site..."
                        store.shouldShowAddServerField = true
                    }, label: {
                        Label("Add server", systemImage: "plus.circle")
                    })
                }, label: {
                    Label(store.siteSelectorDisplay, systemImage: "list.bullet")
                })
            }
            
            if store.shouldShowAddServerField {
                TextField(text: $store.userSiteUrlString, label: { Text("Server URL") })
                    .keyboardType(.URL)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            }
            
            Text(store.selectedSiteName ?? "")
            Text(store.selectedSiteDescription ?? "")
            
            TextField(text: $store.username, label: { Text("Username or email") })
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
            SecureField(text: $store.password, label: { Text("Password") })
            
            Button(action: {
                executing(action: store.submit, errorHandler: errorHandling)
            }, label: {
                Text("Sign in")
            })
            
        }
        .padding(.medium)
        .task(id: store.userSiteUrlString, duration: .milliseconds(500), errorHandler: errorHandling, task: {
            try? await store.userSiteUrlStringUpdated()
        })
        .task(errorHandler: errorHandling, task: {
            try await store.load()
        })
        .withErrorHandling(errorHandling: errorHandling)
    }
}
