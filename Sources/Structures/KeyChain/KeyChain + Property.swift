//
//  KeyChain + Property.swift
//  ViewCollection
//
//  Created by Vaida on 2025-07-05.
//

import Essentials
import Foundation
import Security


extension KeyChain {
    
    /// A value that represents a proxy to `KeyChain` item.
    public struct Property<Value> {
        
        let identifier: String
        
        let service: String
        
        
        // MARK: - Get
        @usableFromInline
        internal func getData() async throws -> Data {
            try await self.query(account: self.identifier)
        }
        
        @inlinable
        public func get() async throws -> Value where Value == Data {
            try await self.getData()
        }
        
        @inlinable
        public func get() async throws -> Value where Value == String {
            let data = try await self.getData()
            return String(data: data, encoding: .utf8)!
        }
        
        @inlinable
        public func get() async throws -> Value where Value == Int {
            let data = try await self.getData()
            return Int(data: data)
        }
        
        @inlinable
        public func get() async throws -> Value where Value: RawRepresentable, Value.RawValue == String {
            let data = try await self.getData()
            let string = String(data: data, encoding: .utf8)!
            return Value(rawValue: string)!
        }
        
        @inlinable
        public func get() async throws -> Value where Value: RawRepresentable, Value.RawValue == Int {
            let data = try await self.getData()
            let int = Int(data: data)
            return Value(rawValue: int)!
        }
        
        // MARK: - Set
        @usableFromInline
        internal func set(data: Data) async throws {
            try await self.persist(data, account: self.identifier)
        }
        
        
        @inlinable
        public func set(_ value: Value) async throws where Value == Data {
            try await self.set(data: value)
        }
        
        @inlinable
        public func set(_ value: Value) async throws where Value == String {
            try await self.set(data: value.data(using: .utf8)!)
        }
        
        @inlinable
        public func set(_ value: Value) async throws where Value == Int {
            try await self.set(data: value.data)
        }
        
        @inlinable
        public func set(_ value: Value) async throws where Value: RawRepresentable, Value.RawValue == String {
            try await self.set(data: value.rawValue.data(using: .utf8)!)
        }
        
        @inlinable
        public func set(_ value: Value) async throws where Value: RawRepresentable, Value.RawValue == Int {
            try await self.set(data: value.rawValue.data)
        }
        
        
        // MARK: - Delete
        /// Removes a key stored in keyChain.
        public func delete() async throws {
            try await self.delete(account: self.identifier)
        }
        
        
        // MARK: - Internal
        /// Persist the given data to keyChain service.
        ///
        /// This method will automatically update the value if it exists.
        private func persist(_ data: Data, account: String) async throws {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: self.service,
                kSecAttrAccount as String: account,
                kSecValueData as String: data
            ]
            
            let status = SecItemAdd(query as CFDictionary, nil)
            if status != errSecSuccess {
                if status == -25299 {
                    try await update(data, account: account)
                } else {
                    throw KeyChain.Error(status: status)
                }
            }
        }
        
        /// Query the first match of given account and identifier.
        private func query(account: String) async throws -> Data {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: self.service,
                kSecAttrAccount as String: account,
                kSecMatchLimit as String: kSecMatchLimitOne,
                kSecReturnData as String: true
            ]
            
            var item: CFTypeRef?
            let status = SecItemCopyMatching(query as CFDictionary, &item)
            guard status == errSecSuccess, let data = item as? Data else { throw KeyChain.Error(status: status) }
            
            return data
        }
        
        /// Removes a key stored in keyChain.
        private func delete(account: String) async throws {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: self.service,
                kSecAttrAccount as String: account
            ]
            
            let status = SecItemDelete(query as CFDictionary)
            guard status == errSecSuccess else { throw KeyChain.Error(status: status) }
        }
        
        /// Updates the given data to keyChain service.
        private func update(_ data: Data, account: String) async throws {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: self.service,
                kSecAttrAccount as String: account
            ]
            
            let payload: [String: Any] = [kSecValueData as String: data]
            
            let status = SecItemUpdate(query as CFDictionary, payload as CFDictionary)
            guard status == errSecSuccess else { throw KeyChain.Error(status: status) }
        }
        
    }
    
}
