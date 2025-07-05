//
//  KeyChain + Key.swift
//  ViewCollection
//
//  Created by Vaida on 2025-07-05.
//

import Foundation


extension KeyChain {
    
    /// A key for defaults lookup
    public struct Key<Value> {
        
        @usableFromInline
        let identifier: String
        
    }
    
}


extension KeyChain.Key {
    
    /// Internal use only, initialize placeholder value.
    @inlinable
    internal init(_ identifier: String) where Value == Void {
        self.identifier = identifier
    }
    
    /// Initialize a new defaults key.
    ///
    /// - Parameters:
    ///   - identifier: The identifier for the given key.
    @inlinable
    public init(_ identifier: String) where Value == Data {
        self.identifier = identifier
    }
    
    /// Initialize a new defaults key.
    ///
    /// - Parameters:
    ///   - identifier: The identifier for the given key.
    @inlinable
    public init(_ identifier: String) where Value == String {
        self.identifier = identifier
    }
    
    /// Initialize a new defaults key.
    ///
    /// - Parameters:
    ///   - identifier: The identifier for the given key.
    @inlinable
    public init(_ identifier: String) where Value == Int {
        self.identifier = identifier
    }
    
    /// Initialize a new defaults key.
    ///
    /// - Parameters:
    ///   - identifier: The identifier for the given key.
    @inlinable
    public init(_ identifier: String) where Value: RawRepresentable, Value.RawValue == String {
        self.identifier = identifier
    }
    
    /// Initialize a new defaults key.
    ///
    /// - Parameters:
    ///   - identifier: The identifier for the given key.
    @inlinable
    public init(_ identifier: String) where Value: RawRepresentable, Value.RawValue == Int {
        self.identifier = identifier
    }
    
}
