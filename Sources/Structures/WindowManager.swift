//
//  WindowManager.swift
//  ViewCollection
//
//  Created by Vaida on 10/7/24.
//

#if os(macOS)
import SwiftUI


/// macOS explicit manager for `NSWindow`.
///
/// ## Topics
/// ### Open Windows
/// - ``open(title:view:styleMask:initialSize:hiding:undoManager:)``
/// - ``openPanel(title:view:initialSize:undoManager:)``
///
/// ### Properties
/// - ``window``
///
/// ### Inheritance
/// - ``windowWillClose(_:)``
/// - ``windowDidResignKey(_:)``
/// - ``windowWillReturnUndoManager(_:)``
public final class WindowManager: NSObject, NSWindowDelegate {
    
    /// The underlying window.
    public private(set) var window: NSWindow? = nil
    
    private var isPanel: Bool? = nil
    
    private var identifier: String? = nil
    
    private var undoManager: UndoManager? = nil
    
    
    /// Open the view in a new window, or pop the exiting window if any.
    ///
    /// - Parameters:
    ///   - title: The window title///   - identifier: This unique id of this window, and used to identify the window using `NSWindow.identifier.rawValue`..
    ///   - identifier: This unique id of this window, and used to identify the window using `NSWindow.identifier.rawValue`.
    ///   - view: The view body of the window.
    ///   - styleMask: The window stye.
    ///   - initialSize: The initial size of the window. However, if previous windows states exists, this value is ignored.
    ///   - hiding: Choose which window buttons to hide.
    ///   - undoManager: The undo manager associated with the resulting window.
    ///
    /// - Warning: The window won’t appear correctly if neither `initialSize` nor SwiftUI size constraints are set.
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
    ///
    /// In the current design, the title bar appears transparent, and the title bar separator is none.
    ///
    /// - Note: When a window is closed, either by user or by calling `window.close()`, a window manager is reset. This ensures SwiftUI will call `onDisappear`.
    @MainActor public func open(
        title: LocalizedStringResource,
        identifier: String,
        view: some View,
        styleMask: NSWindow.StyleMask = [.fullSizeContentView, .titled, .closable, .resizable, .miniaturizable],
        initialSize: CGSize? = nil,
        hiding: [NSWindow.ButtonType] = [],
        undoManager: UndoManager? = nil
    ) {
        self.identifier = identifier
        self.undoManager = undoManager
        
        if let window {
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
        window.title = title.localized()
        window.identifier = .init(rawValue: identifier)
        
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
    ///   - title: The window title, which is hidden.
    ///   - identifier: This unique id of this window, and used to identify the window using `NSWindow.identifier.rawValue`.
    ///   - view: The view body of the window.
    ///   - initialSize: The initial size of the window. However, if previous windows states exists, this value is ignored.
    ///   - undoManager: The undo manager associated with the resulting window.
    @MainActor public func openPanel(
        title: LocalizedStringResource,
        identifier: String,
        view: some View,
        initialSize: CGSize? = nil,
        undoManager: UndoManager? = nil
    ) {
        self.isPanel = true
        self.identifier = identifier
        self.undoManager = undoManager
        
        if let window {
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
        window.title = title.localized()
        window.identifier = .init(rawValue: identifier)
        
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
        if let identifier, let window {
            UserDefaults.standard.set(NSStringFromRect(window.frame), forKey: "NSWindow Frame \(identifier)")
        }
        self.reset()
    }
    
    public func windowDidResignKey(_ notification: Notification) {
        guard self.isPanel ?? false else { return }
        self.window?.close()
    }
    
    public func windowWillReturnUndoManager(_ window: NSWindow) -> UndoManager? {
        self.undoManager
    }
    
    private func reset() {
        self.window = nil
        self.isPanel = nil
        self.identifier = nil
        self.undoManager = nil
    }
}
#endif
