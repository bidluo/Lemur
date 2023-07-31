import Foundation
import SwiftUI


struct ServerAddView: View {
    var body: some View {
        VStack {
            TextField(text: .constant(""), label: { Text("Server address") })
                .keyboardType(.URL)
            
            List {
                
            }
            .listSectionSpacing(.compact)
            .listStyle(.insetGrouped)
            
            Button(action: {
                
            }, label: {
                Text(verbatim: "Submit")
            })
        }
        .padding(.small)
    }
}
