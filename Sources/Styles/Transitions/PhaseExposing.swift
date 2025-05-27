//
//  PhaseExposingTransition.swift
//  ViewCollection
//
//  Created by Vaida on 2025-05-28.
//

import SwiftUI


public struct PhaseExposingTransition: Transition {
    
    @Binding var phase: TransitionPhase?
    
    public func body(content: Content, phase: TransitionPhase) -> some View {
        content
            .onChange(of: phase, initial: true) { oldValue, newValue in
                self.phase = newValue
            }
    }
    
    public init(phase: Binding<TransitionPhase?>) {
        self._phase = phase
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
    
    public func transitionPhaseExposing() -> some View {
        modifier(PhaseExposingViewModifier())
    }
    
}


extension EnvironmentValues {
    @Entry public var transitionPhase: TransitionPhase?
}
