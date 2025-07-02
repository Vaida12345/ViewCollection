//
//  SoftControlButtonStyle.swift
//  ViewCollection
//
//  Created by Vaida on 4/2/25.
//

import SwiftUI
import ViewCollection


/// A Soft style that brings forward the button
///
/// ![Preview](SoftControlButtonStyle)
public struct SoftControlButtonStyle: ButtonStyle {
    
    let isAnimated: Bool
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    @Environment(\.softButtonPaddingDisabled) private var softButtonPaddingDisabled
    @Environment(\.softUIShadowRadius) private var softUIShadowRadius
    
    @Environment(\.transitionPhase) private var transitionPhase
    var phaseMultiplier: Double {
        guard let transitionPhase else { return isAnimated ? 0 : 1 }
        return transitionPhase == .identity ? 1 : 0
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        let radius = (!isEnabled ? 2 : configuration.isPressed ? 1 : softUIShadowRadius ?? 4) * phaseMultiplier
        
        configuration.label
            .symbolVariant(.fill)
            .foregroundColor(Color.soft.secondary)
            .fontWeight(.medium)
            .fontDesign(.rounded)
            .padding(.all, softButtonPaddingDisabled ? 0 : nil)
            .animation(.spring) {
                $0.opacity(phaseMultiplier)
            }
            .modifier(SoftOuterShadowBackground())
            .softShadowRadius(radius)
            .transaction { transaction in
                if configuration.isPressed {
                    transaction.animation = transaction.animation?.speed(4)
                }
            }
            .animation(.spring, value: radius)
#if !os(visionOS)
            .sensoryFeedback(trigger: configuration.isPressed) { oldValue, newValue in
                    .impact(flexibility: .soft, intensity: newValue ? 1.0 : 0.7)
            }
#endif
    }
    
    /// Indicates that transitions should be shown on view appear.
    ///
    /// > Warning: When `animated`, the view must attach `transitionPhaseExposing()`
    /// > ```swift
    /// > Button(...)
    /// >     .buttonStyle(.soft(shape: .capsule).animated())
    /// >     .transitionPhaseExposing()
    /// > ```
    public func animated(_ animated: Bool = true) -> SoftButtonStyle {
        SoftButtonStyle(isAnimated: animated)
    }
    
}


extension ButtonStyle where Self == SoftControlButtonStyle {
    
    /// A Soft style that brings forward the button
    ///
    /// ![Preview](SoftControlButtonStyle)
    public static var softControl: SoftControlButtonStyle {
        SoftControlButtonStyle(isAnimated: false)
    }
    
}


#Preview {
    @Previewable @State var showSecondary = false
    
    ZStack {
        Color.soft.main.ignoresSafeArea(.all)
        
        Button {
            withAnimation {
                showSecondary.toggle()
            }
        } label: {
            Image(systemName: showSecondary ? "play" : "pause")
                .resizable()
                .frame(width: 20, height: 23)
                .contentTransition(.symbolEffect)
        }
        .buttonStyle(.softControl)
        .padding()
    }
    .colorScheme(.dark)
}
