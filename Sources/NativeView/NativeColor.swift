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


extension NativeColor {
    
    public func mix(
        with color: NativeColor,
        by fraction: CGFloat
    ) -> NativeColor {
        var firstComponents = (red: 0.0 as CGFloat, green: 0.0 as CGFloat, blue: 0.0 as CGFloat, alpha: 0.0 as CGFloat)
        var secondComponents = (red: 0.0 as CGFloat, green: 0.0 as CGFloat, blue: 0.0 as CGFloat, alpha: 0.0 as CGFloat)
        
        self.getRed(&firstComponents.red, green: &firstComponents.green, blue: &firstComponents.blue, alpha: &firstComponents.alpha)
        color.getRed(&secondComponents.red, green: &secondComponents.green, blue: &secondComponents.blue, alpha: &secondComponents.alpha)
        
        return NativeColor(
            red: (1 - fraction) * firstComponents.red + fraction * secondComponents.red,
            green: (1 - fraction) * firstComponents.green + fraction * secondComponents.green,
            blue: (1 - fraction) * firstComponents.blue + fraction * secondComponents.blue,
            alpha: (1 - fraction) * firstComponents.alpha + fraction * secondComponents.alpha
        )
    }
}
