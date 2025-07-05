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
/// KeyChain.<#identifier#>
/// ```
///
/// To delete a value, assign it to `nil`.
@dynamicMemberLookup
public struct KeyChain {
    
    public static subscript(dynamicMember keyPath: KeyPath<KeyChain.Key<Void>, KeyChain.Key<Data>>) -> Data? {
        get {
            let key = Key<Void>("")[keyPath: keyPath]
            guard let data = KeyChain.query(account: key.identifier) else { return nil }
            return data
        }
        set {
            let key = Key<Void>("")[keyPath: keyPath]
            
            if let newValue {
                KeyChain.persist(newValue, account: key.identifier)
            } else {
                KeyChain.delete(account: key.identifier)
            }
        }
    }
    
    public static subscript(dynamicMember keyPath: KeyPath<KeyChain.Key<Void>, KeyChain.Key<String>>) -> String? {
        get {
            let key = Key<Void>("")[keyPath: keyPath]
            guard let data = KeyChain.query(account: key.identifier) else { return nil }
            return String(data: data, encoding: .utf8)!
        }
        set {
            let key = Key<Void>("")[keyPath: keyPath]
            
            if let newValue {
                KeyChain.persist(newValue.data(using: .utf8)!, account: key.identifier)
            } else {
                KeyChain.delete(account: key.identifier)
            }
        }
    }
    
    public static subscript(dynamicMember keyPath: KeyPath<KeyChain.Key<Void>, KeyChain.Key<Int>>) -> Int? {
        get {
            let key = Key<Void>("")[keyPath: keyPath]
            guard let data = KeyChain.query(account: key.identifier) else { return nil }
            return Int(data: data)
        }
        set {
            let key = Key<Void>("")[keyPath: keyPath]
            
            if let newValue {
                KeyChain.persist(newValue.data, account: key.identifier)
            } else {
                KeyChain.delete(account: key.identifier)
            }
        }
    }
    
    public static subscript<T>(dynamicMember keyPath: KeyPath<KeyChain.Key<Void>, KeyChain.Key<T>>) -> T? where T: RawRepresentable, T.RawValue == String {
        get {
            let key = Key<Void>("")[keyPath: keyPath]
            guard let data = KeyChain.query(account: key.identifier) else { return nil }
            return T(rawValue: String(data: data, encoding: .utf8)!)
        }
        set {
            let key = Key<Void>("")[keyPath: keyPath]
            
            if let newValue {
                KeyChain.persist(newValue.rawValue.data(using: .utf8)!, account: key.identifier)
            } else {
                KeyChain.delete(account: key.identifier)
            }
        }
    }
    
    public static subscript<T>(dynamicMember keyPath: KeyPath<KeyChain.Key<Void>, KeyChain.Key<T>>) -> T? where T: RawRepresentable, T.RawValue == Int {
        get {
            let key = Key<Void>("")[keyPath: keyPath]
            guard let data = KeyChain.query(account: key.identifier) else { return nil }
            return T(rawValue: Int(data: data))
        }
        set {
            let key = Key<Void>("")[keyPath: keyPath]
            
            if let newValue {
                KeyChain.persist(newValue.rawValue.data, account: key.identifier)
            } else {
                KeyChain.delete(account: key.identifier)
            }
        }
    }
    
    
    // MARK: - Internal
    /// Persist the given data to keyChain service.
    ///
    /// This method will automatically update the value if it exists.
    private static func persist(_ data: Data, account: String, identifier: String = Bundle.main.bundleIdentifier!) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: identifier,
            kSecAttrAccount as String: account,
            kSecValueData as String: data
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        if status != errSecSuccess {
            if status == -25299 {
                update(data, account: account, identifier: identifier)
            } else {
                logError(action: "persist", code: status)
            }
        }
    }
    
    /// Query the first match of given account and identifier.
    private static func query(account: String, identifier: String = Bundle.main.bundleIdentifier!) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: identifier,
            kSecAttrAccount as String: account,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: true
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess, let data = item as? Data else { logError(action: "load", code: status); return nil }
        
        return data
    }
    
    /// Removes a key stored in keyChain.
    private static func delete(account: String, identifier: String = Bundle.main.bundleIdentifier!) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: identifier,
            kSecAttrAccount as String: account
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess else { logError(action: "delete", code: status); return }
    }
    
    /// Updates the given data to keyChain service.
    private static func update(_ data: Data, account: String, identifier: String = Bundle.main.bundleIdentifier!) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: identifier,
            kSecAttrAccount as String: account
        ]
        
        let payload: [String: Any] = [kSecValueData as String: data]
        
        let status = SecItemUpdate(query as CFDictionary, payload as CFDictionary)
        guard status == errSecSuccess else { logError(action: "update", code: status); return }
    }
    
    
    private static func logError(action: String, code: OSStatus) {
        let logger = Logger(subsystem: "KeyChain", function: "subscript")
        logger.error("Failed to \(action): \(SecCopyErrorMessageString(code, nil) as String? ?? "OSStatus code \(code)")")
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
        
        
        fileprivate init(status: OSStatus) {
            self.status = status
        }
    }
}
