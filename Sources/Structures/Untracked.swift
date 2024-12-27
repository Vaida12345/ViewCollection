//
//  Untracked.swift
//  ViewCollection
//
//  Created by Vaida on 12/25/24.
//


/// A property wrapper type that can read and write a value without changing the states to SwiftUI.
///
/// You can use this property wrapper to declare untracked SwiftUI values, similar to `@State`.
///
/// - Warning: Only use ``Untracked`` when you are certain the value is not used in `ViewBuilder`, otherwise the states may be reset unexpectedly.
@propertyWrapper
public final class Untracked<Value> {
    
    /// The underlying value referenced by the untracked variable.
    public var wrappedValue: Value
    
    @inlinable
    public init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }
    
}
