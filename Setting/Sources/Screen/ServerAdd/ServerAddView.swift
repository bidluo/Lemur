import Foundation
import SwiftUI
import Common

struct ServerAddView: View {
    
    @State private var store = ServerAddStore()
    @State private var errorHandler = ErrorHandling()
    @EnvironmentObject private var serversChangedNotifier: ServersChangedNotifier
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                if store.serverName.isEmpty == false {
                    Section {
                        Text(store.serverName)
                        Text(store.serverDescription)
                    }
                }
                
                Section(content: {
                    Text("lemmy.world")
                        .searchCompletion("lemmy.world")
                    Text("lemmy.ml")
                        .searchCompletion("lemmy.ml")
                }, header: {
                    Text("Recommendations")
                })
            }
            .safeAreaInset(edge: .bottom, content: {
                Button(action: {
                    executing(action: store.submit, errorHandler: errorHandler, completion: {
                        serversChangedNotifier.changed()
                        dismiss()
                    })
                }, label: {
                    Text("Add server")
                })
            })
            .safeAreaInset(edge: .top, content: {
                if store.isSearching {
                    ProgressView()
                        .padding(.medium)
                }
            })
            .listSectionSpacing(.compact)
            .listStyle(.insetGrouped)
            .searchable(text: $store.urlString, isPresented: .constant(true), prompt: Text("Enter server URL"))
            .keyboardType(.URL)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .navigationTitle("Add server")
            .navigationBarTitleDisplayMode(.inline)
            .withErrorHandling(errorHandling: errorHandler)
            .task(id: store.urlString, duration: .milliseconds(500), errorHandler: errorHandler, task: {
                try await store.search()
            })
        }
    }
}
