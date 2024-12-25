//
//  WindowManager.swift
//  ViewCollection
//
//  Created by Vaida on 10/7/24.
//

#if os(macOS)
import SwiftUI


public final class WindowManager: NSObject, NSWindowDelegate {
    
    private var isClosed: Bool = false
    
    private var window: NSWindow? = nil
    
    private var isPanel: Bool? = nil
    
    private var title: String? = nil
    
    private var undoManager: UndoManager? = nil
    
    
    /// Open the view in a new window, or pop the exiting window if any.
    ///
    /// - Parameters:
    ///   - title: The window title, which is hidden. It is used to identify the view and restore window position.
    ///   - view: The view body of the window.
    ///   - styleMask: The window stye.
    ///   - initialSize: The initial size of the window. However, if previous windows states exists, this value is ignored.
    ///   - hiding: Choose which window buttons to hide.
    ///   - undoManager: The undo manager associated with the resulting window.
    ///
    /// > Example:
    /// > ```swift
    /// > source.tuningWindow.open(
    /// >     title: "Tuning Window",
    /// >     view: ContentView(),
    /// >     styleMask: [.fullSizeContentView, .titled, .closable, .resizable, .miniaturizable],
    /// >     initialSize: CGSize(width: 1200, height: 800)
    /// > )
    /// > ```
    ///
    /// ## Close Window Command
    ///
    /// The close window command is hidden by default for `Window`, but shown for `WindowGroup`. In that case, create a new `Command` of
    ///
    /// ```swift
    /// CommandGroup(after: .saveItem)
    /// ```
    ///
    /// - Bug: In the current design, one window can only handle one view, and thats it. It cannot be changed.
    @MainActor public func open(
        title: String,
        view: some View,
        styleMask: NSWindow.StyleMask,
        initialSize: CGSize? = nil,
        hiding: [NSWindow.ButtonType] = [],
        undoManager: UndoManager? = nil
    ) {
        self.title = title
        self.undoManager = undoManager
        
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
        window.title = title
        
        for hide in hiding {
            window.standardWindowButton(hide)?.isHidden = true
        }
        
        window.makeKeyAndOrderFront(nil)
        
        if let historySize = UserDefaults.standard.string(forKey: "NSWindow Frame \(title)") {
            window.setFrame(NSRectFromString(historySize), display: true)
        } else if let initialSize {
            window.setFrame(CGRect(origin: window.frame.origin, size: initialSize), display: true)
        }
        
        self.window = window
    }
    
    /// Open the view in a new window, or pop the exiting window if any.
    ///
    /// This window is similar to Xcode library, it has no window control buttons, and it is closed when lost focus.
    ///
    /// > Example:
    /// > ```swift
    /// > manager.openPanel(
    /// >     title: "panel",
    /// >     view: ContentView()
    /// >              .background(BlurredEffectView()),
    /// > )
    /// > ```
    ///
    /// - Parameters:
    ///   - title: The window title, which is hidden. It is used to identify the view and restore window position.
    ///   - view: The view body of the window.
    ///   - initialSize: The initial size of the window. However, if previous windows states exists, this value is ignored.
    ///   - undoManager: The undo manager associated with the resulting window.
    @MainActor public func openPanel(
        title: String,
        view: some View,
        initialSize: CGSize? = nil,
        undoManager: UndoManager? = nil
    ) {
        self.isPanel = true
        self.title = title
        self.undoManager = undoManager
        
        if let window, !isClosed {
            window.orderFront(nil)
            window.becomeKey()
            return
        }
        
        let viewController = NSHostingController(
            rootView: view
        )
        
        let window = NSPanel(contentViewController: viewController)
        window.delegate = self
        
        window.standardWindowButton(.zoomButton)?.isHidden = true
        window.standardWindowButton(.closeButton)?.isHidden = true
        window.standardWindowButton(.miniaturizeButton)?.isHidden = true
        
        window.titlebarSeparatorStyle = .none
        window.titleVisibility = .hidden
        
        window.styleMask = [.titled, .fullSizeContentView]
        window.backingType = .buffered
        window.titlebarAppearsTransparent = true
        window.title = title
        
        // Set window properties
        window.isFloatingPanel = true  // Keeps it above other windows
        window.isMovableByWindowBackground = true  // Click and drag anywhere to move
        window.hasShadow = true
        
        window.makeKeyAndOrderFront(nil)
        
        if let historySize = UserDefaults.standard.string(forKey: "NSWindow Frame \(title)") {
            window.setFrame(NSRectFromString(historySize), display: true)
        } else if let initialSize {
            window.setFrame(CGRect(origin: window.frame.origin, size: initialSize), display: true)
        }
        
        self.window = window
    }
    
    public func windowWillClose(_ notification: Notification) {
        isClosed = true
        
        if let title, let window {
            UserDefaults.standard.set(NSStringFromRect(window.frame), forKey: "NSWindow Frame \(title)")
        }
    }
    
    public func windowDidResignKey(_ notification: Notification) {
        guard self.isPanel ?? false else { return }
        self.window?.close()
        self.isPanel = true
    }
    
    public func windowWillReturnUndoManager(_ window: NSWindow) -> UndoManager? {
        self.undoManager
    }
}
#endif
