//
//  DataProvider.swift
//  The Nucleus Module
//
//  Created by Vaida on 6/13/22.
//  Copyright © 2019 - 2023 Vaida. All rights reserved.
//

import Foundation
import FinderItem
import SwiftUI


/// The provider for the main storable workflow of data.
///
/// ## Inheritance
/// Create a `final class` that inherits from this protocol, and add `instance` to the class declaration.
///
/// ```swift
/// @Observable
/// final class <#Model#>: DataProvider {
///     static var instance = <#Model#>.load()
/// }
/// ```
///
/// ## Use instance
/// To use the instance, observe the model in main app.
/// ```swift
/// @State private var <#model#> = <#Model#>.instance
/// ```
///
/// ## AutoSave
/// The auto saving can be achieved using `AppDelegate`.
///
/// Define the `AppDelegate`.
/// ```swift
/// final class AppDelegate: ApplicationDelegate {
///     override func applicationWillTerminate() {
///         try? <#Model#>.instance.save()
///     }
/// }
/// ```
///
/// Link the delegate within the `@main App`.
/// ```swift
/// @ApplicationDelegateAdaptor(AppDelegate.self)
/// private var appDelegate
/// ```
public protocol DataProvider: Codable, Identifiable, AnyObject {
    
    /// The main ``DataProvider`` to work with.
    ///
    /// In the `@main App` declaration, declare a `StateObject` of `instance`. In this way, this structure can be accessed across the app, and any mutation is observed in all views.
    nonisolated(unsafe)
    static var instance: Self { get set }
    
    /// Creates the default value.
    ///
    /// The default value is used when opening the app for the first time, or restoring states results in failure.
    init()
    
}


extension DataProvider {
    
    /// The path indicating the location where this ``DataProvider`` is persisted on disk.
    @inlinable
    public static var storageLocation: FinderItem {
        .homeDirectory/"Library/Application Support/DataProviders/\(Self.self).plist"
    }
    
    /// Save the encoded provider to ``storageLocation`` using `.plist`.
    @inlinable
    public nonisolated func save() throws {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .binary
        try Self.storageLocation.enclosingFolder.makeDirectory()
        try encoder.encode(self).write(to: Self.storageLocation)
    }
    
    /// Load the saved model, or create a new one using its default initializer.
    public static func load() -> Self {
        do {
            return try Self.init(at: Self.storageLocation, format: .plist)
        } catch {
            return Self.init()
        }
    }
    
}
