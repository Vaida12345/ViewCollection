//
//  SwiftUI.swift
//  ViewCollection
//
//  Created by Vaida on 9/26/24.
//

import SwiftUI


// MARK: - SwiftUI Convenience Initializers

extension GridItem {
    
    /// Creates a single item with the specified fixed size.
    ///
    /// This initializer uses the default parameters for `spacing` and `alignment`.
    ///
    /// - Parameters:
    ///   - size: the specified fixed size.
    @inlinable
    public static func fixed(_ size: CGFloat, spacing: CGFloat? = nil, alignment: Alignment? = nil) -> GridItem {
        GridItem(.fixed(size), spacing: spacing, alignment: alignment)
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
    @inlinable
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
    ///
    /// - SeeAlso: `showsExtendedToolbar`
    @MainActor
    @inlinable
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
    
    /// Whether the tool bar is extended.
    @MainActor
    @inlinable
    public var showsExtendedToolbar: Bool {
        switch DesignPattern.current {
        case .iPhone:
            if #available(anyAppleOS 27.1, *) {
                if toolbarVerticalEdge != nil {
                    // vertical toolbar, this is the iPhone Duo fully extended portrait mode.
                    // `verticalSizeClass == .regular` alone is not sufficient for showing extended toolbar.
                    verticalSizeClass == .regular && horizontalSizeClass == .regular
                } else {
                    if verticalSizeClass == .compact && horizontalSizeClass == .compact {
                        true // both compact means it is a small screen AND not vertical, as apparently it is SwiftUI behavior that with the same screen, when portrait, the vertical size class is regular, but when landscape, the horizontal size class is compact.
                    } else {
                        horizontalSizeClass == .regular
                    }
                }
            } else {
                verticalSizeClass == .compact // only show in landscape mode, as it rules out iPhone Duo, the only one with different design in iPhone class.
            }
        case .iPad:
            horizontalSizeClass == .regular
        default:
            true // always show extended.
        }
    }
    
}


extension LocalizedStringKey.StringInterpolation {
    
    /// Append a localized subject.
    @inlinable
    public mutating func appendInterpolation(_ subject: some CustomLocalizedStringResourceConvertible) {
        self.appendInterpolation(subject.localizedStringResource)
    }
    
}


/// Executes a closure without animation and returns the result.
///
/// This is the opposite of `withAnimation`, disable animations usually associated with an action, such as sheet presentation.
@inlinable
public func withoutAnimation<R>(action: () throws -> R) rethrows -> R {
    try withTransaction(\.disablesAnimations, true) {
        try action()
    }
}
