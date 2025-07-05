//
//  Defaults.swift
//  ViewCollection
//
//  Created by Vaida on 2025-07-05.
//

import Foundation


/// A type-safe wrapper to `UserDefaults`.
///
/// To declare a user default key
/// ```swift
/// extension Defaults.Key where Value == Void {
///     var <#identifier#>: Defaults.Key<<#Type#>> {
///         .init(<#identifier#>, default: <#default#>)
///     }
/// }
/// ```
///
/// Then, you can access the value stored in `UserDefaults` via
/// ```swift
/// Defaults.standard.<#identifier#>
/// ```
///
/// ## Integration with SwiftUI
/// You can retrieve and observe defaults using `AppStorage`
/// ```swift
/// @AppStorage(\.memorySaver) private var memorySaver
/// ```
@dynamicMemberLookup
public struct Defaults {
    
    private let userDefaults: UserDefaults
    
    /// A global instance of `Defaults` configured to search the current application's search list.
    public static var standard: Defaults {
        Defaults(userDefaults: .standard)
    }
    
    /// Creates a user defaults object initialized with the defaults for the specified database name.
    public static func suite(name: String) -> Defaults? {
        guard let userDefaults = UserDefaults(suiteName: name) else { return nil }
        return Defaults(userDefaults: userDefaults)
    }
    
    public subscript<T>(dynamicMember keyPath: KeyPath<Defaults.Key<Void>, Defaults.Key<T>>) -> T {
        get {
            let key = Key("", default: ())[keyPath: keyPath]
            
            let object = userDefaults.object(forKey: key.identifier)
            if object == nil { return key.defaultValue }
            
            guard let value = object as? T else {
                preconditionFailure("Type associated with \"\(key.identifier)\" mismatch; expected: \(T.self), actual: \(String(describing: type(of: object!))).")
            }
            
            return value
        }
        set {
            let key = Key("", default: ())[keyPath: keyPath]
            
            userDefaults.set(newValue, forKey: key.identifier)
        }
    }
}
