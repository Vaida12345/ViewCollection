//
//  AppDelegate.swift
//  ViewCollection
//
//  Created by Vaida on 12/13/24.
//

import SwiftUI


#if os(macOS)
/// A wrapper to `NSApplicationDelegateAdaptor`
typealias ApplicationDelegateAdaptor = NSApplicationDelegateAdaptor
#elseif os(iOS)
/// A wrapper to `UIApplicationDelegateAdaptor`
typealias ApplicationDelegateAdaptor = UIApplicationDelegateAdaptor
#endif

#if os(macOS)

/// A wrapper to `NSApplicationDelegate`
///
/// By default, the app will be closed when the last windows is closed. This could be overridden using `applicationShouldTerminateAfterLastWindowClosed`.
public class ApplicationDelegate: NSObject, NSApplicationDelegate {
    
    /// Tells the delegate that the app is about to terminate.
    func applicationWillTerminate() {
        
    }
    
}

extension ApplicationDelegate {
    
    public func applicationWillTerminate(_ notification: Notification) {
        self.applicationWillTerminate()
    }
    
    @objc
    public func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }
    
}

#elseif os(iOS)

/// A wrapper to `UIApplicationDelegate`
public protocol ApplicationDelegate: UIApplicationDelegate {
    
    /// Tells the delegate that the app is about to terminate.
    func applicationWillTerminate()
    
}

extension ApplicationDelegate {
    
    public func applicationWillTerminate(_ application: UIApplication) {
        applicationWillTerminate()
    }
    
}

#endif
