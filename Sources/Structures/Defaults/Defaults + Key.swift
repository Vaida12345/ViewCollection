//
//  Defaults + Key.swift
//  ViewCollection
//
//  Created by Vaida on 2025-07-05.
//


extension Defaults {
    
    /// A key for defaults lookup
    public struct Key<Value> {
        
        @usableFromInline
        let identifier: String
        
        @usableFromInline
        let defaultValue: Value
        
        
        /// Initialize a new defaults key.
        ///
        /// - Parameters:
        ///   - identifier: The identifier for the given key.
        ///   - defaultValue: The default value for the given key. The default value will be used when there does not exist a value associated with `identifier`.
        ///
        /// - Warning: You need to ensure the `identifier` is used uniquely. `preconditionError` will be thrown if the type associated with a key is unexpected.
        @inlinable
        public init(_ identifier: String, default defaultValue: Value) {
            self.identifier = identifier
            self.defaultValue = defaultValue
        }
        
    }
    
}
