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
    static let allColors: [Color] = [.red, .orange, .yellow, .green, .mint, .teal, .cyan, .blue, .indigo, .purple, .pink, .brown, .white, .gray, .black]
    
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
    
}


extension Color: @retroactive Animatable {
    
    @inlinable
    public var animatableData: Vector<Double> {
        get {
#if canImport(AppKit) && !targetEnvironment(macCatalyst)
            let color = NSColor(self).usingColorSpace(.sRGB)!
            return Vector([color.redComponent, color.greenComponent, color.blueComponent, color.alphaComponent])
#elseif canImport(UIKit)
            let color = UIColor(self).cgColor.converted(to: CGColorSpace(name: CGColorSpace.displayP3)!, intent: .defaultIntent, options: nil)!
            return Vector(color.components!.map { Double($0) })
#endif
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
