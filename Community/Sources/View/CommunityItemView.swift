import Foundation
import Common
import SwiftUI

struct CommunityItemView: View {
    
    let community: GetCommunitiesUseCase.Result.Community
    
    static let thumbnailSize = 20.0
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                if let thumbnailUrl = community.thumbnailUrl {
                    AsyncImage(url: thumbnailUrl.thumbnail(size: Int(Self.thumbnailSize))) { image in
                        image.image?.resizable()
                            .frame(width: Self.thumbnailSize, height: Self.thumbnailSize)
                            .clipShape(Circle())
                            .clipped()
                    }
                    .frame(width: Self.thumbnailSize, height: Self.thumbnailSize)
                } else if let initial = community.name.first {
                    Text(String(initial))
                        .font(.subheadingBold)
                        .frame(width: Self.thumbnailSize, height: Self.thumbnailSize)
                        .background(Colour.brandPrimary.swiftUIColor)
                        .clipShape(Circle())
                        .clipped()
                }
                
                Text(community.name)
                    .font(.subheadingSemiBold)
                    .fontDesign(.rounded)
            }
            
            Text(community.description)
                .font(.captionStandard)
                .lineLimit(3)
            Spacer()
            
            HStack(spacing: Size.large.rawValue) {
                Spacer()
                Label(title: { Text(String(community.postCount)) }, icon: { Image(systemName: "book.pages.fill") })
                Label(title: { Text(String(community.subsciberCount)) }, icon: { Image(systemName: "person.3.fill") })
                Label(title: { Text(String(community.dailyActiveUserCount)) }, icon: { Image(systemName: "person.crop.circle.badge.fill") })
            }
            .labelStyle(.spacing(Size.extraSmall.rawValue))
            .font(Typography.footnote.font)
            .fontDesign(.monospaced)
        }
    }
}
