//
//  AppDelegate.swift
//  ViewCollection
//
//  Created by Vaida on 12/13/24.
//

import SwiftUI


#if os(macOS)
/// A wrapper to `NSApplicationDelegateAdaptor`
public typealias ApplicationDelegateAdaptor = NSApplicationDelegateAdaptor
#elseif os(iOS)
/// A wrapper to `UIApplicationDelegateAdaptor`
public typealias ApplicationDelegateAdaptor = UIApplicationDelegateAdaptor
#endif

#if os(macOS)

/// A wrapper to `NSApplicationDelegate`
///
/// By default, the app will be closed when the last windows is closed. This could be overridden using `applicationShouldTerminateAfterLastWindowClosed`.
open class ApplicationDelegate: NSObject, NSApplicationDelegate {
    
    /// Tells the delegate that the app is about to terminate.
    open func applicationWillTerminate() {
        
    }
    
}

extension ApplicationDelegate {
    
    open func applicationWillTerminate(_ notification: Notification) {
        self.applicationWillTerminate()
    }
    
    open func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }
    
}

#elseif os(iOS)

/// A wrapper to `UIApplicationDelegate`
open class ApplicationDelegate: NSObject, UIApplicationDelegate {
    
    /// Tells the delegate that the app is about to terminate.
    open func applicationWillTerminate() {
        
    }
    
}

extension ApplicationDelegate {
    
    open func applicationWillTerminate(_ application: UIApplication) {
        applicationWillTerminate()
    }
    
}

#endif
