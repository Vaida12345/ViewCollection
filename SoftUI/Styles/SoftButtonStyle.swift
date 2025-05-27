//
//  SoftButtonStyle.swift
//  ViewCollection
//
//  Created by Vaida on 4/2/25.
//

import SwiftUI
import ViewCollection


public struct SoftButtonStyle<S: Shape>: ButtonStyle {
    
    let shape: S
    let isAnimated: Bool
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    @Environment(\.transitionPhase) private var transitionPhase
    
    var phaseMultiplier: Double {
        guard let transitionPhase else { return isAnimated ? 0 : 1 }
        return transitionPhase == .identity ? 1 : 0
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        let radius = (!isEnabled ? 2 : configuration.isPressed ? 1.0 : 4) * phaseMultiplier
        
        configuration.label
            .foregroundColor(Color.soft.secondary)
            .animation(.spring) {
                $0.opacity(phaseMultiplier)
            }
            .background {
                SoftOuterShadow(shape: shape)
                    .softShadowRadius(radius)
                    .transaction { transaction in
                        if configuration.isPressed {
                            transaction.animation = transaction.animation?.speed(4)
                        }
                    }
                    .animation(.spring, value: radius)
            }
            .sensoryFeedback(trigger: configuration.isPressed) { oldValue, newValue in
                    .impact(flexibility: .soft, intensity: newValue ? 1.0 : 0.7)
            }
    }
    
    /// Indicates that transitions should be shown on view appear.
    ///
    /// - Warning: When `animated`, the view must attach `transitionPhaseExposing()`
    public func animated(_ animated: Bool = true) -> SoftButtonStyle {
        SoftButtonStyle(shape: shape, isAnimated: animated)
    }
    
}


extension ButtonStyle where Self == SoftButtonStyle<AnyShape> {
    
    /// A Soft UI style button
    public static func soft<S: Shape>(shape: S) -> SoftButtonStyle<S> {
        SoftButtonStyle(shape: shape, isAnimated: false)
    }
    
}


#Preview {
    @Previewable @State var showSecondary = false
    
    ZStack {
        Color.soft.main.ignoresSafeArea(.all)
        
        VStack {
            Button {
                withAnimation {
                    showSecondary.toggle()
                }
            } label: {
                Text("Hit Me!")
                    .padding()
            }
            .buttonStyle(.soft(shape: .capsule))
            .padding()
            
            if showSecondary {
                Button {
                    
                } label: {
                    Text("Secondary")
                        .padding()
                }
                .buttonStyle(.soft(shape: .capsule).animated())
                .transitionPhaseExposing()
                
                Spacer()
            } else {
                Spacer()
            }
        }
    }
    .colorScheme(.dark)
}
