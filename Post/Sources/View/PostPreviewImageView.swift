import Foundation
import SwiftUI
import Common

struct PostPreviewImageView: View {
    var imageUrl: URL?
    var isPreview: Bool = true
    
    var body: some View {
        AsyncImageCache(url: imageUrl, clipped: isPreview)
    }
}


actor ImageCache {
    private var cache = NSCache<NSURL, UIImage>()
    
    func get(_ url: URL) -> UIImage? {
        return cache.object(forKey: url as NSURL)
    }
    
    func set(_ image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url as NSURL)
    }
}

struct AsyncImageCache: View {
    @Environment(\.imageCache) var cache: ImageCache
    @Environment(\.dismiss) var dismiss
    let url: URL?
    let clipped: Bool
    @State var image: Image?
    
    init(url: URL?, clipped: Bool) {
        self.url = url
        self.clipped = clipped
    }
    
    var body: some View {
        Group {
            if let _image = self.image {
                _image
                    .resizable()
                    .if(clipped == false) { view in
                        view.modifier(
                            InteractiveImageModifier(onDismiss: {
                                dismiss()
                            })
                        )
                    }
            } else {
                Color.gray
            }
        }.onAppear {
            Task {
                await loadImage(thumbnailSize: 720)
            }
        }
        .onChange(of: url, { old, new in
            if old == nil, new != nil {
                Task {
                    await loadImage(thumbnailSize: 720)
                }
            }
        })
    }
    
    private func loadImage(thumbnailSize: CGFloat) async {
        guard let _url = self.url else { return }
        do {
            if let image = await cache.get(_url) {
                self.image = Image(uiImage: image)
            } else {
                let (data, _) = try await URLSession.shared.data(from: _url.thumbnail(size: Int(thumbnailSize)))
                if let image = UIImage(data: data) {
                    await cache.set(image, for: _url)
                    self.image = Image(uiImage: image)
                }
            }
        } catch {
            print("Failed to load image for \(_url): \(error)")
        }
    }
}

struct ImageCacheKey: EnvironmentKey {
    static let defaultValue: ImageCache = ImageCache()
}

extension EnvironmentValues {
    var imageCache: ImageCache {
        get { return self[ImageCacheKey.self] }
        set { self[ImageCacheKey.self] = newValue }
    }
}
