//
//  SwiftUI.swift
//  ViewCollection
//
//  Created by Vaida on 9/26/24.
//

import SwiftUI
import Matrix


// MARK: - SwiftUI Convenience Initializers

extension GridItem {
    
    /// Creates a single item with the specified fixed size.
    ///
    /// This initializer uses the default parameters for `spacing` and `alignment`.
    ///
    /// - Parameters:
    ///   - size: the specified fixed size.
    public static func fixed(_ size: CGFloat) -> GridItem {
        GridItem(.fixed(size))
    }
    
}

// MARK: - Color

public extension Color {
    
    /// The system-defined colors.
    static let allColors: [Color] = [.red, .orange, .yellow, .green, .mint, .teal, .cyan, .blue, .indigo, .purple, .pink, .brown, .gray]
    
}


extension Color: Codable {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let red =   try container.decode(CGFloat.self, forKey: .red)
        let green = try container.decode(CGFloat.self, forKey: .green)
        let blue =  try container.decode(CGFloat.self, forKey: .blue)
        let alpha = try container.decodeIfPresent(CGFloat.self, forKey: .alpha) ?? 1
        
        self.init(.displayP3, red: red, green: green, blue: blue, opacity: alpha)
    }
    
    public func encode(to encoder: Encoder) throws {
#if canImport(AppKit) && !targetEnvironment(macCatalyst)
        let color = NSColor(self).usingColorSpace(.displayP3)!
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(color.redComponent,   forKey: .red)
        try container.encode(color.greenComponent, forKey: .green)
        try container.encode(color.blueComponent,  forKey: .blue)
        if color.alphaComponent != 1 { try container.encode(color.alphaComponent, forKey: .alpha) }
#elseif canImport(UIKit)
        let color = UIColor(self).cgColor.converted(to: CGColorSpace(name: CGColorSpace.displayP3)!, intent: .defaultIntent, options: nil)!
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(color.components![0],   forKey: .red)
        try container.encode(color.components![1],   forKey: .green)
        try container.encode(color.components![2],   forKey: .blue)
        if color.alpha != 1 { try container.encode(color.alpha, forKey: .alpha) }
#endif
    }
    
    private enum CodingKeys: CodingKey {
        case red, green, blue, alpha
    }
    
    /// Creates a context-dependent color with different values for light and dark appearances.
    /// 
    /// - Parameters:
    ///   - light: The light appearance color value.
    ///   - dark: The dark appearance color value.
    public init(light: @escaping () -> Color, dark: @escaping () -> Color) {
#if os(watchOS)
        self = dark()
#elseif canImport(UIKit)
        self.init(
            uiColor: .init { traitCollection in
                switch traitCollection.userInterfaceStyle {
                case .unspecified, .light:
                    return UIColor(light())
                case .dark:
                    return UIColor(dark())
                @unknown default:
                    return UIColor(light())
                }
            }
        )
#elseif canImport(AppKit)
        self.init(
            nsColor: .init(name: nil) { appearance in
                if appearance.bestMatch(from: [.aqua, .darkAqua]) == .aqua {
                    return NSColor(light())
                } else {
                    return NSColor(dark())
                }
            }
        )
#endif
    }
    
}


extension Color: @retroactive Animatable {
    
    public var components: [Double] {
#if canImport(AppKit) && !targetEnvironment(macCatalyst)
        let color = NSColor(self).usingColorSpace(.displayP3)!
        return [color.redComponent, color.greenComponent, color.blueComponent, color.alphaComponent]
#elseif canImport(UIKit)
        let color = UIColor(self).cgColor.converted(to: CGColorSpace(name: CGColorSpace.displayP3)!, intent: .defaultIntent, options: nil)!
        return color.components!.map { Double($0) }
#endif
    }
    
    @inlinable
    public var animatableData: Vector<Double> {
        get {
            Vector(self.components)
        }
        set(newValue) {
            self = .init(.displayP3, red: newValue[0], green: newValue[1], blue: newValue[2], opacity: newValue[3])
        }
    }
    
}


extension Color: @retroactive Identifiable {
    
    public var id: String {
        self.description
    }
    
}


extension GraphicsContext {
    
    /// Draws a path into the context and fills the outlined region.
    ///
    /// The current drawing state of the context defines the
    /// full drawing operation. For example, the current transformation and
    /// clip shapes, and any styles applied to the result, affect the final
    /// result.
    ///
    /// - Parameters:
    ///   - rect: The outline of the region to fill.
    ///   - shading: The color or pattern to use when filling the region
    ///     bounded by `path`.
    ///   - style: A style that indicates how to rasterize the path.
    public func fill(_ rect: CGRect, with shading: GraphicsContext.Shading, style: FillStyle = FillStyle()) {
        self.fill(Path(rect), with: shading, style: style)
    }
    
}


extension EnvironmentValues {
    
    /// Whether the horizontal menu bar is extended.
    ///
    /// This environment value aims to differentiate whether the iPhone is landscape or portrait, and if the iPad is in split screen.
    ///
    /// ---
    ///
    /// This value returns `true` when
    /// - iPhone is in landscape mode
    /// - iPad is not in split screen
    /// - any other device
    @MainActor
    var showsExtendedMenubar: Bool {
        switch DesignPattern.current {
        case .iPhone:
            verticalSizeClass == .compact // only show in landscape mode.
        case .iPad:
            horizontalSizeClass == .regular
        default:
            true // always show extended.
        }
    }
    
}
