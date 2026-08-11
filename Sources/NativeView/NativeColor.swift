//
//  NativeColor.swift
//  ViewCollection
//
//  Created by Vaida on 11/21/24.
//

#if canImport (AppKit) && !targetEnvironment (macCatalyst)

import AppKit

public typealias NativeColor = NSColor

#elseif canImport(UIKit)

import UIKit

public typealias NativeColor = UIColor
#endif

import ColorComponents


extension NativeColor {
    
    public func mix(
        with color: NativeColor,
        by fraction: CGFloat
    ) -> NativeColor {
#if canImport (AppKit) && !targetEnvironment (macCatalyst)
        self.components.mix(with: color.components, by: fraction).nsColor
#else
        self.components.mix(with: color.components, by: fraction).uiColor
#endif
    }
    
    
    public convenience init(components: ColorComponents) {
#if canImport (AppKit) && !targetEnvironment (macCatalyst)
        self.init(srgbRed: components.red, green: components.green, blue: components.blue, alpha: components.alpha)
#else
        self.init(red: components.red, green: components.green, blue: components.blue, alpha: components.alpha)
#endif
    }
}
