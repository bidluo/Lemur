import Foundation

extension URL {
    public func thumbnail(size: Int) -> URL {
        return self.appending(
            queryItems: [
                URLQueryItem(name: "thumbnail", value: String(size)),
                URLQueryItem(name: "format", value: "webp")
                
            ]
        )
    }
}
