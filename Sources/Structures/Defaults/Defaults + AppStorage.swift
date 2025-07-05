//
//  Defaults + AppStorage.swift
//  ViewCollection
//
//  Created by Vaida on 2025-07-05.
//

import SwiftUI


extension AppStorage {
    
    /// Creates a property that can read and write to a boolean user default.
    @inlinable
    public init(_ keyPath: KeyPath<Defaults.Key<Void>, Defaults.Key<Value>>) where Value == Bool {
        let key = Defaults.Key("", default: ())[keyPath: keyPath]
        self.init(wrappedValue: key.defaultValue, key.identifier)
    }
    
    /// Creates a property that can read and write to an integer user default.
    @inlinable
    public init(_ keyPath: KeyPath<Defaults.Key<Void>, Defaults.Key<Value>>) where Value == Int {
        let key = Defaults.Key("", default: ())[keyPath: keyPath]
        self.init(wrappedValue: key.defaultValue, key.identifier)
    }
    
    /// Creates a property that can read and write to a double user default.
    @inlinable
    public init(_ keyPath: KeyPath<Defaults.Key<Void>, Defaults.Key<Value>>) where Value == Double {
        let key = Defaults.Key("", default: ())[keyPath: keyPath]
        self.init(wrappedValue: key.defaultValue, key.identifier)
    }
    
    /// Creates a property that can read and write to a string user default.
    @inlinable
    public init(_ keyPath: KeyPath<Defaults.Key<Void>, Defaults.Key<Value>>) where Value == String {
        let key = Defaults.Key("", default: ())[keyPath: keyPath]
        self.init(wrappedValue: key.defaultValue, key.identifier)
    }
    
    /// Creates a property that can read and write to a url user default.
    @inlinable
    public init(_ keyPath: KeyPath<Defaults.Key<Void>, Defaults.Key<Value>>) where Value == URL {
        let key = Defaults.Key("", default: ())[keyPath: keyPath]
        self.init(wrappedValue: key.defaultValue, key.identifier)
    }
    
    /// Creates a property that can read and write to a date user default.
    @inlinable
    public init(_ keyPath: KeyPath<Defaults.Key<Void>, Defaults.Key<Value>>) where Value == Date {
        let key = Defaults.Key("", default: ())[keyPath: keyPath]
        self.init(wrappedValue: key.defaultValue, key.identifier)
    }
    
    /// Creates a property that can read and write to a user default as data.
    @inlinable
    public init(_ keyPath: KeyPath<Defaults.Key<Void>, Defaults.Key<Value>>) where Value == Data {
        let key = Defaults.Key("", default: ())[keyPath: keyPath]
        self.init(wrappedValue: key.defaultValue, key.identifier)
    }
    
    /// Creates a property that can read and write to an integer user default, transforming that to `RawRepresentable` data type.
    @inlinable
    public init(_ keyPath: KeyPath<Defaults.Key<Void>, Defaults.Key<Value>>) where Value : RawRepresentable, Value.RawValue == Int {
        let key = Defaults.Key("", default: ())[keyPath: keyPath]
        self.init(wrappedValue: key.defaultValue, key.identifier)
    }
    
    /// Creates a property that can read and write to a string user default, transforming that to `RawRepresentable` data type.
    @inlinable
    public init(_ keyPath: KeyPath<Defaults.Key<Void>, Defaults.Key<Value>>) where Value : RawRepresentable, Value.RawValue == String {
        let key = Defaults.Key("", default: ())[keyPath: keyPath]
        self.init(wrappedValue: key.defaultValue, key.identifier)
    }
    
}


extension AppStorage where Value: ExpressibleByNilLiteral {
    
    /// Creates a property that can read and write to a boolean user default.
    @inlinable
    public init(_ keyPath: KeyPath<Defaults.Key<Void>, Defaults.Key<Value>>) where Value == Bool? {
        let key = Defaults.Key("", default: ())[keyPath: keyPath]
        precondition(key.defaultValue == nil, "Optional value must have a default value of `nil` to be used in AppStorage.")
        self.init(key.identifier)
    }
    
    /// Creates a property that can read and write to an integer user default.
    @inlinable
    public init(_ keyPath: KeyPath<Defaults.Key<Void>, Defaults.Key<Value>>) where Value == Int? {
        let key = Defaults.Key("", default: ())[keyPath: keyPath]
        precondition(key.defaultValue == nil, "Optional value must have a default value of `nil` to be used in AppStorage.")
        self.init(key.identifier)
    }
    
    /// Creates a property that can read and write to a double user default.
    @inlinable
    public init(_ keyPath: KeyPath<Defaults.Key<Void>, Defaults.Key<Value>>) where Value == Double? {
        let key = Defaults.Key("", default: ())[keyPath: keyPath]
        precondition(key.defaultValue == nil, "Optional value must have a default value of `nil` to be used in AppStorage.")
        self.init(key.identifier)
    }
    
    /// Creates a property that can read and write to a string user default.
    @inlinable
    public init(_ keyPath: KeyPath<Defaults.Key<Void>, Defaults.Key<Value>>) where Value == String? {
        let key = Defaults.Key("", default: ())[keyPath: keyPath]
        precondition(key.defaultValue == nil, "Optional value must have a default value of `nil` to be used in AppStorage.")
        self.init(key.identifier)
    }
    
    /// Creates a property that can read and write to a url user default.
    @inlinable
    public init(_ keyPath: KeyPath<Defaults.Key<Void>, Defaults.Key<Value>>) where Value == URL? {
        let key = Defaults.Key("", default: ())[keyPath: keyPath]
        precondition(key.defaultValue == nil, "Optional value must have a default value of `nil` to be used in AppStorage.")
        self.init(key.identifier)
    }
    
    /// Creates a property that can read and write to a date user default.
    @inlinable
    public init(_ keyPath: KeyPath<Defaults.Key<Void>, Defaults.Key<Value>>) where Value == Date? {
        let key = Defaults.Key("", default: ())[keyPath: keyPath]
        self.init(key.identifier)
    }
    
    /// Creates a property that can read and write to a user default as data.
    @inlinable
    public init(_ keyPath: KeyPath<Defaults.Key<Void>, Defaults.Key<Value>>) where Value == Data? {
        let key = Defaults.Key("", default: ())[keyPath: keyPath]
        precondition(key.defaultValue == nil, "Optional value must have a default value of `nil` to be used in AppStorage.")
        self.init(key.identifier)
    }
}


extension AppStorage {
    
    /// Creates a property that can read and write to an integer user default, transforming that to `RawRepresentable` data type.
    @inlinable
    public init<R>(_ keyPath: KeyPath<Defaults.Key<Void>, Defaults.Key<Value>>) where Value == R?, R : RawRepresentable, R.RawValue == Int {
        let key = Defaults.Key("", default: ())[keyPath: keyPath]
        precondition(key.defaultValue == nil, "Optional value must have a default value of `nil` to be used in AppStorage.")
        self.init(key.identifier)
    }
    
    /// Creates a property that can read and write to a string user default, transforming that to `RawRepresentable` data type.
    @inlinable
    public init<R>(_ keyPath: KeyPath<Defaults.Key<Void>, Defaults.Key<Value>>) where Value == R?, R : RawRepresentable, R.RawValue == String {
        let key = Defaults.Key("", default: ())[keyPath: keyPath]
        precondition(key.defaultValue == nil, "Optional value must have a default value of `nil` to be used in AppStorage.")
        self.init(key.identifier)
    }
    
}
