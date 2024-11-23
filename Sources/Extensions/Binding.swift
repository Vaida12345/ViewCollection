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
    
}
