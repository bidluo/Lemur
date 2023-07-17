import Foundation
import SwiftUI

// MARK: Size
public enum Size: CGFloat {
    /// 0
    case zero = 0
    
    /// 4
    case extraSmall = 4
    
    /// 8
    case small = 8
    
    /// 12
    case smallMedium = 12
    
    /// 16
    case medium = 16
    
    /// 20
    case mediumLarge = 20
    
    /// 24
    case large = 24
    
    /// 32
    case extraLarge = 32
    
    /// 64
    case doubleExtraLarge = 64
}

// MARK: Typography
public enum Typography {
    /// Title Large: size 28, weight bold
    case titleLarge
    /// Title Standard: size 22, weight bold
    case titleStandard
    /// Title Small: size 20, weight semibold
    case titleSmall
    /// Heading Bold: size 17, weight semibold
    case headingBold
    /// Heading Regular: size 15, weight semibold
    case headingRegular
    /// Subheading Bold: size 15, weight regular
    case subheadingSemiBold
    /// Subheading Regular: size 13, weight semibold
    case subheadingBold
    /// Subheading Regular: size 13, weight bold
    case subheadingRegular
    /// Body Large: size 17, weight regular
    case bodyLarge
    /// Body Standard: size 15, weight regular
    case bodyStandard
    /// Footnote: size 13, weight regular
    case footnote
    /// Caption Large: size 12, weight regular
    case captionLarge
    /// Caption Standard: size 11, weight regular
    case captionStandard
    
    public var font: Font {
        switch self {
        case .titleLarge: .system(size: 28, weight: .bold, design: .default)
        case .titleStandard: .system(size: 22, weight: .bold, design: .default)
        case .titleSmall: .system(size: 20, weight: .semibold, design: .default)
        case .headingBold: .system(size: 17, weight: .semibold, design: .default)
        case .headingRegular: .system(size: 15, weight: .semibold, design: .default)
        case .subheadingBold: .system(size: 15, weight: .bold, design: .default)
        case .subheadingSemiBold: .system(size: 15, weight: .semibold, design: .default)
        case .subheadingRegular: .system(size: 13, weight: .regular, design: .default)
        case .bodyLarge: .system(size: 17, weight: .regular, design: .default)
        case .bodyStandard: .system(size: 15, weight: .regular, design: .default)
        case .footnote: .system(size: 13, weight: .regular, design: .default)
        case .captionLarge: .system(size: 12, weight: .regular, design: .default)
        case .captionStandard: .system(size: 11, weight: .regular, design: .default)
        }
    }
}

// MARK: View+Size
public extension View {
    func padding(_ size: Size) -> some View {
        padding(size.rawValue)
    }
    
    func padding(_ edges: Edge.Set, _ size: Size) -> some View {
        padding(edges, size.rawValue)
    }
}

// MARK: EdgeInsets+Size
public extension EdgeInsets {
    init(_ edges: Edge.Set, size: Size) {
        self.init(
            top: edges.contains(.top) ? size.rawValue : .zero,
            leading: edges.contains(.leading) ? size.rawValue : .zero,
            bottom: edges.contains(.bottom) ? size.rawValue : .zero,
            trailing: edges.contains(.trailing) ? size.rawValue : .zero
        )
    }
}

public extension Text {
    func font(_ typography: Typography) -> Text {
        font(typography.font)
    }
}
