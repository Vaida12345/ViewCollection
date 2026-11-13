//
//  WindowButtonsHiding.swift
//  ViewCollection
//
//  Created by Vaida on 2026-11-14.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import SwiftUI
import AppKit


private struct HideWindowButtons: NSViewRepresentable {
    
    let hiddenTypes: [NSWindow.ButtonType]
    
    func makeNSView(context: Context) -> NSView { Anchor(hiddenTypes: self.hiddenTypes) }
    
    func updateNSView(_ nsView: NSView, context: Context) {
        (nsView as? Anchor)?.hiddenTypes = self.hiddenTypes
    }
    
    private final class Anchor: NSView {
        
        private var observations: [NSKeyValueObservation] = []
        
        var hiddenTypes: [NSWindow.ButtonType] {
            didSet {
                guard hiddenTypes != oldValue, let window else { return }
                
                // Stop observing first, otherwise the observers would hide the buttons again.
                observations = []
                for type in oldValue where !hiddenTypes.contains(type) {
                    window.standardWindowButton(type)?.isHidden = false
                }
                self.hide(in: window)
            }
        }
        
        init(hiddenTypes: [NSWindow.ButtonType]) {
            self.hiddenTypes = hiddenTypes
            super.init(frame: .zero)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func viewDidMoveToWindow() {
            super.viewDidMoveToWindow()
            observations = []
            guard let window else { return }
            
            self.hide(in: window)
        }
        
        // The anchor is invisible, so it must never receive events.
        override func hitTest(_ point: NSPoint) -> NSView? { nil }
        
        private func hide(in window: NSWindow) {
            for type in self.hiddenTypes {
                guard let button = window.standardWindowButton(type) else { continue }
                button.isHidden = true
                observations.append(button.observe(\.isHidden) { button, _ in
                    // Assigning below notifies the observer again, synchronously; that nested call finds the button already hidden and exits at this check.
                    MainActor.assumeIsolated {
                        if !button.isHidden {
                            button.isHidden = true
                        }
                    }
                })
            }
        }
    }
}


extension View {
    
    /// Hides the given standard buttons of the window enclosing this view.
    ///
    /// Apply it to the root content of the scene. The buttons stay hidden even if SwiftUI or AppKit shows them again, and they are not restored when the modifier is removed.
    ///
    /// ```swift
    /// Window("Main", id: "main") {
    ///     ContentView()
    ///         .windowButtons(hiding: [.miniaturizeButton, .zoomButton])
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - buttonTypes: The button types to hide.
    public func windowButtons(hiding buttonTypes: [NSWindow.ButtonType]) -> some View {
        background(HideWindowButtons(hiddenTypes: buttonTypes))
    }
    
}
#endif
