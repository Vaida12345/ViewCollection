//
//  View & SwiftUI Extensions.swift
//  The Stratum Module
//
//  Created by Vaida on 6/22/22.
//  Copyright © 2019 - 2024 Vaida. All rights reserved.
//

import Accelerate
import SwiftUI
import Matrix


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
            return Vector(color.components!.map { Double($0) } + [color.alpha])
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


public extension Picker {
    
    /// Initialize a picker with its `options`.
    ///
    /// - Parameters:
    ///   - title: A localized string key that describes the purpose of selecting an option.
    ///   - selection: A binding to a property that determines the currently-selected option.
    ///   - options: A set of options that builds a `ForEach` view.
    @inlinable
    init(_ title: LocalizedStringKey, selection: Binding<SelectionValue>, options: [SelectionValue]) where SelectionValue: CustomStringConvertible, Label == Text, Content == ForEach<[SelectionValue], SelectionValue, Text> {
        self.init(title, selection: selection) {
            ForEach(options, id: \.self) {
                Text(LocalizedStringKey($0.description))
            }
        }
    }
    
    /// Initialize a picker with its `options`.
    ///
    /// - Parameters:
    ///   - title: A localized string key that describes the purpose of selecting an option.
    ///   - selection: A binding to a property that determines the currently-selected option.
    ///   - options: A set of options that builds a `ForEach` view.
    @inlinable
    init(_ title: LocalizedStringKey = "", selection: Binding<SelectionValue>, options: [SelectionValue]) where SelectionValue: RawRepresentable, SelectionValue.RawValue == String, Label == Text, Content == ForEach<[SelectionValue], SelectionValue, Text> {
        self.init(title, selection: selection) {
            ForEach(options, id: \.self) {
                Text(LocalizedStringKey($0.rawValue))
            }
        }
    }
    
    /// Initialize a picker with a `CaseIterable` enumeration, whose rawValue is string.
    ///
    /// - Remark: The set of options that builds a `ForEach` view are generated from `allCases`.
    ///
    /// - Parameters:
    ///   - title: A localized string key that describes the purpose of selecting an option.
    ///   - selection: A binding to a property that determines the currently-selected option.
    @inlinable
    init(_ title: LocalizedStringKey = "", selection: Binding<SelectionValue>) where SelectionValue: RawRepresentable, SelectionValue.RawValue == String, SelectionValue: CaseIterable, Label == Text, Content == ForEach<SelectionValue.AllCases, SelectionValue, Text> {
        self.init(title, selection: selection) {
            ForEach(SelectionValue.allCases, id: \.self) {
                Text(LocalizedStringKey($0.rawValue))
            }
        }
    }
    
}


public extension View {
    
    /// The mask that does the opposite of `mask(_:,_:)`.
    @inlinable
    func reverseMask<Mask: View>(alignment: Alignment = .center, @ViewBuilder _ mask: () -> Mask) -> some View {
        self.mask(
            ZStack(alignment: alignment) {
                Rectangle()
                
                mask()
                    .blendMode(.destinationOut)
            }
        )
    }
}
