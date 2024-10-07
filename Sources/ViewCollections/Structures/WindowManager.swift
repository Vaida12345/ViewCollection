//
//  WindowManager.swift
//  ViewCollection
//
//  Created by Vaida on 10/7/24.
//

#if os(macOS)
import SwiftUI


public final class WindowManager: NSObject, NSWindowDelegate {
    
    private var isClosed: Bool = true
    
    private var window: NSWindow? = nil
    
    
    /// Open the view in a new window, or pop the exiting window if any.
    @MainActor public func open(_ view: some View, styleMask: NSWindow.StyleMask, initialSize: CGSize? = nil, hiding: [NSWindow.ButtonType] = []) {
        if let window, !isClosed {
            window.orderFront(nil)
            window.becomeKey()
            return
        }
        
        let viewController = NSHostingController(
            rootView: view
        )
        let window = NSWindow(contentViewController: viewController)
        window.delegate = self
        
        window.titlebarSeparatorStyle = .none
        window.titleVisibility = .hidden
        
        window.styleMask = styleMask
        window.titlebarAppearsTransparent = true
        
        for hide in hiding {
            window.standardWindowButton(hide)?.isHidden = true
        }
        
        window.makeKeyAndOrderFront(nil)
        
        window.hasShadow = true
        window.becomeKey()
        
        if let initialSize {
            window.setFrame(CGRect(origin: window.frame.origin, size: initialSize), display: true)
        }
    }
    
    public func windowWillClose(_ notification: Notification) {
        isClosed = true
    }
    
}
#endif
