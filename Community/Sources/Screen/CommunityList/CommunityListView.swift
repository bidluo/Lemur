import SwiftUI
import Common

public struct CommunityListView: CommunityListViewType, View {

    private var store = CommunityListStore()
    
    @State private var navigationPath = NavigationPath()
    
    public init() {
        
    }
    
    public var body: some View {
        NavigationStack(path: $navigationPath) {
            List {
                ForEach(store.rows, id: \.self) { item in
                    Text(item)
                }
            }
        }
        .task {
            try! await store.load()
        }
    }
}

#Preview {
    CommunityListView()
}
