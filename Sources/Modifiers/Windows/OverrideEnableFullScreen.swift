//
//  OverrideEnableFullScreen.swift
//  ViewCollection
//
//  Created by Vaida on 2026-11-14.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import SwiftUI
import AppKit


private struct FullScreenEnabler: NSViewRepresentable {
    func makeNSView(context: Context) -> NSView { Anchor() }
    func updateNSView(_ nsView: NSView, context: Context) {}
    
    private final class Anchor: NSView {
        private var observation: NSKeyValueObservation?
        
        override func viewDidMoveToWindow() {
            super.viewDidMoveToWindow()
            observation = nil
            guard let window else { return }
            
            Self.apply(to: window)
            
            // SwiftUI can rewrite `collectionBehavior` after the view is attached (for example for a window with `windowResizability(.contentSize)`), so applying it once is not enough.
            observation = window.observe(\.collectionBehavior) { window, _ in
                MainActor.assumeIsolated {
                    Self.apply(to: window)
                }
            }
        }
        
        // The anchor is invisible, so it must never receive events.
        override func hitTest(_ point: NSPoint) -> NSView? { nil }
        
        private static func apply(to window: NSWindow) {
            var behavior = window.collectionBehavior
            behavior.remove([.fullScreenAuxiliary, .fullScreenNone])
            behavior.insert(.fullScreenPrimary)
            
            // Assigning below notifies the observer again, synchronously; that nested call finds nothing to change and exits at this guard.
            guard behavior != window.collectionBehavior else { return }
            window.collectionBehavior = behavior
        }
    }
}


extension View {
    
    /// Ensures the full-screen button of the window enclosing this view is enabled.
    ///
    /// SwiftUI does not make every window full-screen capable. This modifier forces the window's `collectionBehavior` to `fullScreenPrimary` and reapplies it whenever SwiftUI changes it, so the full-screen button stays enabled, including for windows with fixed-size content.
    ///
    /// Apply it to the root content of the scene.
    ///
    /// ```swift
    /// Window("Main", id: "main") {
    ///     ContentView()
    ///         .windowOverrideEnableFullScreen()
    /// }
    /// ```
    ///
    /// - SeeAlso: `windowFullScreenBehavior(_:)`, which may not work.
    public func windowOverrideEnableFullScreen() -> some View {
        background(FullScreenEnabler())
    }
    
}
#endif
