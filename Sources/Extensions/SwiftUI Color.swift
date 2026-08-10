//
//  SwiftUI Color.swift
//  ViewCollection
//
//  Created by Vaida on 2026-04-11.
//

import SwiftUI
import ColorComponents


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
        
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let components = self.components
        try container.encode(components[0], forKey: .red)
        try container.encode(components[1], forKey: .green)
        try container.encode(components[2], forKey: .blue)
        if components[3] != 1 { try container.encode(components[3], forKey: .alpha) }
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
    
    @inlinable
    public var animatableData: ColorComponents {
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

extension Color: @retroactive Identifiable {
    
    @inlinable
    public var id: ColorComponents {
        self.components
    }
    
}

extension Color {
    
#if canImport(UIKit)
    /// Returns the list background color on iOS.
    public static let listBackgroundColor = Color(UIColor.secondarySystemBackground)
#endif
    
}
