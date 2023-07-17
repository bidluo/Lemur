import Foundation
import SwiftUI

struct PostPreviewImageView: View {
    var imageUrl: URL?
    
    var body: some View {
        AsyncImageCache(url: imageUrl)
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
    let url: URL?
    @State var image: Image?
    
    init(url: URL?) {
        self.url = url
    }
    
    var body: some View {
        GeometryReader { proxy in
            Group {
                if let _image = self.image {
                    // Helps keep image from drawing out of bounds and also making
                    // the parent grow to try fit, despite clipped being used
                    Color.clear
                        .overlay {
                            _image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        }
                        .clipped()
                } else {
                    Color.gray
                }
            }.onAppear {
                Task {
                    await loadImage(thumbnailSize: proxy.size.width)
                }
            }
            .onChange(of: url, { old, new in
                if old == nil, new != nil {
                    Task {
                        await loadImage(thumbnailSize: proxy.size.width)
                    }
                }
            })
        }
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
