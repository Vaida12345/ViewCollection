//
//  Binding.swift
//  ViewCollection
//
//  Created by Vaida on 11/23/24.
//

import SwiftUI


extension Binding {
    
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
    
}
