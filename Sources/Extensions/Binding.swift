//
//  Binding.swift
//  ViewCollection
//
//  Created by Vaida on 11/23/24.
//

import SwiftUI


extension Binding {
    
    /// Use this method to create an binding on the equatable.
    ///
    /// ```swift
    /// Toggle("Camera", systemImage: "camera.viewfinder", isOn: $popoverContent == .camera)
    /// ```
    public static func ==<T: Sendable> (lhs: Self, rhs: Value) -> Binding<Bool> where T: Equatable, Value == Optional<T> {
        Binding<Bool> {
            lhs.wrappedValue == rhs
        } set: { newValue in
            if newValue {
                lhs.wrappedValue = rhs
            } else {
                lhs.wrappedValue = nil
            }
        }
    }
    
    /// Use this method to create an binding on the equatable.
    ///
    /// ```swift
    /// Toggle("Camera", systemImage: "camera.viewfinder", isOn: $popoverContent != .camera)
    /// ```
    public static func !=<T: Sendable> (lhs: Self, rhs: Value) -> Binding<Bool> where T: Equatable, Value == Optional<T> {
        Binding<Bool> {
            lhs.wrappedValue != rhs
        } set: { newValue in
            if !newValue {
                lhs.wrappedValue = rhs
            } else {
                lhs.wrappedValue = nil
            }
        }
    }
    
    /// Returns `true` is `self` equals to `other`. Or, when the result binding is set to `false`, assign `self` to `falseValue`.
    public func isEqual(to other: Value, or falseValue: Value) -> Binding<Bool> where Value: Equatable & Sendable {
        Binding<Bool> {
            self.wrappedValue == other
        } set: { newValue in
            if newValue {
                self.wrappedValue = other
            } else {
                self.wrappedValue = falseValue
            }
        }
    }
    
}


extension Binding where Value == CGFloat {
    
    /// Access the binding as a `Double`.
    @available(*, deprecated, renamed: "double")
    public var float: Binding<Double> {
        Binding<Double> {
            self.wrappedValue
        } set: {
            self.wrappedValue = $0
        }
    }
    
    /// Access the binding as a `Double`.
    public var double: Binding<Double> {
        Binding<Double> {
            self.wrappedValue
        } set: {
            self.wrappedValue = $0
        }
    }
    
}
