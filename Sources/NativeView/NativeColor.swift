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


extension UIColor {
    
    public func blended(
        withFraction fraction: CGFloat,
        of color: UIColor
    ) -> UIColor? {
        var firstComponents = (red: 0.0 as CGFloat, green: 0.0 as CGFloat, blue: 0.0 as CGFloat, alpha: 0.0 as CGFloat)
        var secondComponents = (red: 0.0 as CGFloat, green: 0.0 as CGFloat, blue: 0.0 as CGFloat, alpha: 0.0 as CGFloat)
        
        guard self.getRed(&firstComponents.red, green: &firstComponents.green, blue: &firstComponents.blue, alpha: &firstComponents.alpha),
              color.getRed(&secondComponents.red, green: &secondComponents.green, blue: &secondComponents.blue, alpha: &secondComponents.alpha) else {
            return nil
        }
        
        let blendAlpha = (1 - fraction) * firstComponents.alpha + fraction * secondComponents.alpha
        
        let blendedColor = UIColor(
            red: (1 - fraction) * firstComponents.red + fraction * secondComponents.red,
            green: (1 - fraction) * firstComponents.green + fraction * secondComponents.green,
            blue: (1 - fraction) * firstComponents.blue + fraction * secondComponents.blue,
            alpha: blendAlpha
        )
        return blendedColor
    }
}
#endif
