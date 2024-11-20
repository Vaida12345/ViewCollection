//
//  BlurredEffectView.swift
//  The ViewCollection Module
//
//  Created by Vaida on 1/11/23.
//  Copyright © 2019 - 2024 Vaida. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import SwiftUI


/// A effect when applied to a view, the background is the blurred home screen.
///
/// **View Modifiers**
///
/// The following view modifiers can be applied to `@main App`.
///
/// Apply this effect view as a material on the window background.
/// ```swift
/// .background(BlurredEffectView().ignoresSafeArea())
/// ```
///
/// To hide tool bar,
/// ```swift
/// .windowStyle(.hiddenTitleBar)
/// ```
///
/// To have the window size fixed,
/// ```swift
/// .windowResizability(.contentSize)
/// ```
///
/// **Example App**
///
/// ```swift
/// WindowGroup {
///     ContentView()
///         .background(BlurredEffectView().ignoresSafeArea())
///     }
/// }
/// .windowStyle(.hiddenTitleBar)
/// ```
///
/// ![View Example](blurredEffectView)
public struct BlurredEffectView: NSViewRepresentable {
    
    /// Creates the effect view.
    @inlinable
    public func makeNSView(context: Context) -> NSVisualEffectView {
        let effect = NSVisualEffectView()
        effect.state = .active
        return effect
    }
    
    /// Update the effect view.
    @inlinable
    public func updateNSView(_ view: NSVisualEffectView, context: Context) { }
    
    /// Creates a blurred effect view.
    ///
    /// Apply this effect view as a material on the window background.
    /// ```swift
    /// .background(BlurredEffectView().ignoresSafeArea())
    /// ```
    @inlinable
    public init() { }
    
}
#endif
