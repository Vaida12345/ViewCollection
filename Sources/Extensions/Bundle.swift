//
//  Bundle.swift
//  ViewCollection
//
//  Created by Vaida on 10/12/24.
//

import Foundation


public extension Bundle {
    
    /// Loads the given key from the bundle, returns `nil` if not present.
    func load(_ key: ResourceKey) -> String? {
        self.infoDictionary?[key.rawValue] as? String
    }
    
    enum ResourceKey: String {
        
        /// The user-visible name for the bundle, used by Siri and visible on the iOS Home screen.
        ///
        /// If this value is `nil`, system uses ``bundleName``.
        case displayName = "CFBundleDisplayName"
        
        /// The name of the bundle’s executable file.
        case executableFile = "CFBundleExecutable"
        
        /// The file containing the bundle's icon.
        case iconFile = "CFBundleIconFile"
        
        /// The name of the asset that represents the app icon.
        case iconName = "CFBundleIconName"
        
        /// A user-visible short name for the bundle.
        case bundleName = "CFBundleName"
        
        /// The release or version number of the bundle.
        ///
        /// - Experiment: This is something like *1.3.1*.
        case versionString = "CFBundleShortVersionString"
        
        /// The version of the build that identifies an iteration of the bundle.
        ///
        /// - Experiment: This is something like *44*.
        case version = "CFBundleVersion"
        
        /// A human-readable copyright notice for the bundle.
        case copyright = "NSHumanReadableCopyright"
        
    }
    
}
