import SwiftUI
import Common

public struct CommunityListView: View {

    @State private var store = CommunityListStore()
    @State private var errorHandler = ErrorHandling()
    @EnvironmentObject private var provider: Common.ViewProvider
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    public init() {
        
    }
    
    public var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Menu(content: {
                    ForEach(store.sites, id: \.url) { site in
                        Button(action: {
                            store.selectedSite = site
                        }, label: {
                            Text(site.name)
                        })
                    }
                }, label: {
                    if let selectedSite = store.selectedSite {
                        Text("Communities for \(selectedSite.name)")
                    } else {
                        Text("Select site...")
                    }
                })
                .padding(.horizontal, .medium)
                
                if horizontalSizeClass == .compact {
                    listContent
                } else {
                    gridContent
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing, content: {
                    Menu(content: {
                        ForEach(store.mainItems, id: \.self) { item in
                            Button(action: {
                                store.selectedSort = item
                                executing(action: { try await store.reload() }, errorHandler: errorHandler)
                            }, label: { Text(item.rawValue) })
                        }
                        
                        Menu(content: {
                            ForEach(store.topItems, id: \.self) { item in
                                Button(action: {
                                    store.selectedSort = item
                                    executing(action: { try await store.reload() }, errorHandler: errorHandler)
                                }, label: { Text(item.rawValue) })
                            }
                        }, label: {
                            Text("Top...")
                        })
                        
                        Menu(content: {
                            ForEach(store.commentItems, id: \.self) { item in
                                Button(action: {
                                    store.selectedSort = item
                                    executing(action: { try await store.reload() }, errorHandler: errorHandler)
                                }, label: { Text(item.rawValue) })
                            }
                        }, label: {
                            Text("Comments...")
                        })
                    }, label: {
                        switch store.selectedSort {
                        case .hot: Image(systemName: "flame.fill")
                        case .active: Image(systemName: "bolt.fill")
                        case .new: Image(systemName: "hourglass.tophalf.filled")
                        case .old: Image(systemName: "hourglass.bottomhalf.filled")
                        case .mostComments, .newComments: Image(systemName: "bubble.left.and.bubble.right.fill")
                        default: Image(systemName: "crown.fill")
                        }
                    })
                })
            }
            .navigationTitle("Communities")
            .task {
                try? await store.load()
            }
            .task(id: store.selectedSite?.url, errorHandler: errorHandler, task: {
                try await store.loadCommunities()
            })
            .navigationDestination(for: GetCommunitiesUseCase.Result.Community.self, destination: { community in
                provider.postProvider?.listView(siteUrl: community.siteUrl, communityId: community.id)
                    .id(community.id)
            })
        }
    }
    
    private var gridContent: some View {
        ScrollView {
            LazyVGrid(columns: [.init(), .init()], alignment: .leading) {
                ForEach(store.rows, id: \.id) { item in
                    NavigationLink(value: item, label: {
                        CommunityItemView(community: item)
                            .padding(.medium)
                            .containerRelativeFrame(.horizontal, count: 2, span: 1, spacing: 16.0, alignment: .leading)
                            .background(RectangleBackground())
                    })
                    .isDetailLink(true)
                    .buttonStyle(.plain)
                }
            }
        }
    }
    
    private var listContent: some View {
        List {
            ForEach(store.rows, id: \.id) { item in
                NavigationLinkWithoutChevron(value: item, label: {
                    CommunityItemView(community: item)
                        .padding(.vertical, .medium)
                        .padding(.horizontal, .small)
                })
            }
            .alignmentGuide(.listRowSeparatorLeading, computeValue: { _ in return 0 })
        }
    }
}

#Preview {
    CommunityListView()
}
