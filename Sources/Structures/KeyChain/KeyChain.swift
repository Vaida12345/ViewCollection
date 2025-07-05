//
//  KeyChain.swift
//  ViewCollection
//
//  Created by Vaida on 2025-07-05.
//

import OSLog
import Essentials
import Foundation
import Security


/// A type-safe wrapper to KeyChain Service.
///
/// To declare a keychain key
/// ```swift
/// extension KeyChain.Key where Value == Void {
///     var <#identifier#>: KeyChain.Key<<#Type#>> {
///         .init(<#identifier#>)
///     }
/// }
/// ```
///
/// Then, you can access the value stored in KeyChain via
/// ```swift
/// KeyChain.standard.<#identifier#>.get()
/// ```
///
/// To delete a value, assign it to `nil`.
@dynamicMemberLookup
public struct KeyChain {
    
    let service: String
    
    /// A global instance of `KeyChain` configured to the current application.
    public static var standard: KeyChain {
        KeyChain(service: Bundle.main.bundleIdentifier!)
    }
    
    /// A keychain with the given service name.
    public static func service(_ service: String) -> KeyChain {
        KeyChain(service: service)
    }
    
    public subscript<T>(dynamicMember keyPath: KeyPath<KeyChain.Key<Void>, KeyChain.Key<T>>) -> Property<T> {
        let key = Key<Void>("")[keyPath: keyPath]
        return Property(identifier: key.identifier, service: self.service)
    }
    
    /// An error. as a wrapper to `OSStatus`.
    public struct Error: GenericError {
        
        private let status: OSStatus
        
        public var title: String? {
            "Keychain error"
        }
        
        public var message: String {
            SecCopyErrorMessageString(status, nil) as String? ?? "OSStatus code \(status)"
        }
        
        
        init(status: OSStatus) {
            self.status = status
        }
    }
}
