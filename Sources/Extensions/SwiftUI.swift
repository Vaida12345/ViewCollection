//
//  SwiftUI.swift
//  ViewCollection
//
//  Created by Vaida on 9/26/24.
//

import SwiftUI
import simd


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


extension Color: @retroactive Codable {
    
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
    
    /// The components of the color.
    ///
    /// Layout in `[red, green, blue, alpha]`.
    @inlinable
    public var components: SIMD4<Double> {
#if canImport(AppKit) && !targetEnvironment(macCatalyst)
        let color = NSColor(self).usingColorSpace(.sRGB)!
        var components = SIMD4<Double>.zero
        withUnsafeMutableBytes(of: &components) { pointer in
            pointer.withMemoryRebound(to: CGFloat.self) { buffer in
                color.getComponents(buffer.baseAddress!)
            }
        }
        return components
#elseif canImport(UIKit)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        if UIColor(self).getRed(&r, green: &g, blue: &b, alpha: &a) {
            return SIMD4<Double>(r, g, b, a)
        } else {
            let color = UIColor(self).cgColor.converted(to: CGColorSpace(name: CGColorSpace.sRGB)!, intent: .defaultIntent, options: nil)!
            let components = color.components!
            return SIMD4<Double>(components[0], components[1], components[2], components[3])
        }
#endif
    }
    
    @inlinable
    public var animatableData: SIMD4<Double> {
        get {
            self.components
        }
        set(newValue) {
            self = Color(components: newValue)
        }
    }
    
    /// Creates a color with its components.
    @inlinable
    public init(_ colorSpace: RGBColorSpace = .sRGB, components: SIMD4<Double>) {
        self.init(colorSpace, red: components[0], green: components[1], blue: components[2], opacity: components[3])
    }
    
}


extension SIMD4: @retroactive AdditiveArithmetic, @retroactive VectorArithmetic where Scalar == Double {
    
    @inlinable
    public mutating func scale(by rhs: Double) {
        self *= rhs
    }
    
    @inlinable
    public var magnitudeSquared: Double {
        simd_dot(self, self)
    }
    
}


extension Color: @retroactive Identifiable {
    
    public var id: SIMD4<Double> {
        self.components
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
    /// This environment value aims to tell if you can put more content in the menu bar.
    ///
    /// ---
    ///
    /// This value returns `true` when
    /// - iPhone is in landscape mode
    /// - iPad window is wide enough
    /// - any other device
    @MainActor
    public var showsExtendedMenubar: Bool {
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


extension LocalizedStringKey.StringInterpolation {
    
    /// Append a localized subject.
    public mutating func appendInterpolation(_ subject: some CustomLocalizedStringResourceConvertible) {
        self.appendInterpolation(subject.localizedStringResource)
    }
    
}
