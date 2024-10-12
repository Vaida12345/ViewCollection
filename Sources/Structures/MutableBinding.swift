//
//  MutableBinding.swift
//  The Stratum Module
//
//  Created by Vaida on 7/12/23.
//  Copyright © 2019 - 2024 Vaida. All rights reserved.
//


import Foundation
import SwiftUI


/// A `Binding` that represents UI elements data, that can be mutated and passed as arguments to any function, without breaking isolation.
///
/// To create a mutable binding, use `$instance.mutable`.
///
/// ## Topics
/// ### Creates the binding
/// - ``SwiftUI/Binding/mutable``
@MainActor
public final class MutableBinding<T>: Sendable {
    
    private let content: Binding<T>
    
    /// Use wrapped value to mutate or retrieve the binding.
    @MainActor
    public var wrappedValue: T {
        get { self.get() }
        set { self.set(newValue) }
    }
    
    /// Sets the value of binding.
    @MainActor
    public func set(_ content: T) {
        self.content.wrappedValue = content
    }
    
    /// Retrieves the value within the binding.
    @MainActor
    public func get() -> T {
        self.content.wrappedValue
    }
    
    fileprivate init(content: Binding<T>) {
        self.content = content
    }
    
}

extension Binding {
    
    /// Applied to a `Binding` to obtain the mutable binding.
    ///
    /// - SeeAlso: ``MutableBinding``
    @MainActor
    public var mutable: MutableBinding<Value> {
        MutableBinding(content: self)
    }
    
}
