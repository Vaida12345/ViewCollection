//
//  PhaseExposingTransition.swift
//  ViewCollection
//
//  Created by Vaida on 2025-05-28.
//

import SwiftUI


struct PhaseExposingTransition: Transition {
    
    @Binding var phase: TransitionPhase?
    
    func body(content: Content, phase: TransitionPhase) -> some View {
        content
            .onChange(of: phase, initial: true) { oldValue, newValue in
                self.phase = newValue
            }
    }
}


struct PhaseExposingViewModifier: ViewModifier {
    
    @State private var phase: TransitionPhase? = nil
    
    func body(content: Content) -> some View {
        content
            .transition(PhaseExposingTransition(phase: $phase))
            .environment(\.transitionPhase, phase)
    }
    
}


extension View {
    
    /// A transition style that exposes the underlying transition phase to the environment.
    ///
    /// This transition allows implementations to choose the desired transition by acting on the `transitionPhase` environment value.
    ///
    /// To correctly expose the environment value, this modifier must be applied on a parent view of the custom view. For example, `SoftUI` provides a custom implementation of transition,
    /// ```swift
    /// Button(...)
    ///     .buttonStyle(.soft(shape: .capsule).animated())
    ///     .transitionPhaseExposing()
    /// ```
    public func transitionPhaseExposing() -> some View {
        modifier(PhaseExposingViewModifier())
    }
    
}


extension EnvironmentValues {
    @Entry public var transitionPhase: TransitionPhase?
}
