import Foundation
import SwiftUI
import Common

struct MainSideBarView: View {
    
    @UseCaseStream private var useCase: GetSubscribedCommunitiesUseCase
    @EnvironmentObject private var provider: Common.ViewProvider
    @State private var needsLoad = true
    @State private var sections: [SideBarSection] = []
    
    private struct SideBarSection: Hashable {
        let title: String
        let items: [GetSubscribedCommunitiesUseCase.Result.Community]
    }
    
    var body: some View {
        List {
            Section(content: {
                NavigationLink(destination: {
                    provider.postProvider?.listView(siteUrl: nil, communityId: nil)
                        .id("all")
                }, label: {
                    Text("All")
                })
            }, header: {
                Text("Sites")
            })
            
            ForEach(sections, id: \.self) { section in
                Section(content: {
                    ForEach(section.items, id: \.id) { item in
                        NavigationLink(value: item, label: { 
                            HStack {
                                AsyncImage(url: item.icon) { image in
                                    image.image?.resizable()
                                        .frame(width: 20, height: 20)
                                        .clipShape(Circle())
                                        .clipped()
                                }
                                Text(item.name)
                            }
                        })
                    }
                }, header: {
                    Text(section.title)
                })
            }
        }
        .task {
            try? await load()
        }
        .navigationDestination(for: GetSubscribedCommunitiesUseCase.Result.Community.self, destination: { community in
            provider.postProvider?.listView(siteUrl: community.siteUrl, communityId: community.id)
                .id(community.id)
        })
    }
    
    private func load() async throws {
        guard needsLoad else { return }
        defer {
            needsLoad = false
        }
        
        for try await communities in await useCase.call() {
            sections = communities.communities.map { item in
                return SideBarSection(title: item.key, items: item.value)
            }
        }
    }
}
