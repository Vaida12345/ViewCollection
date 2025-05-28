//
//  SoftButtonStyle.swift
//  ViewCollection
//
//  Created by Vaida on 4/2/25.
//

import SwiftUI
import ViewCollection


public struct SoftButtonStyle: ButtonStyle {
    
    let isAnimated: Bool
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    @Environment(\.softUIShape) private var shape
    
    @Environment(\.transitionPhase) private var transitionPhase
    var phaseMultiplier: Double {
        guard let transitionPhase else { return isAnimated ? 0 : 1 }
        return transitionPhase == .identity ? 1 : 0
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        let radius = (!isEnabled ? 2 : configuration.isPressed ? 1.0 : 4) * phaseMultiplier
        
        configuration.label
            .foregroundColor(Color.soft.secondary)
            .fontWeight(.medium)
            .fontDesign(.rounded)
            .padding()
            .animation(.spring) {
                $0.opacity(phaseMultiplier)
            }
            .background {
                SoftOuterShadow()
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


extension ButtonStyle where Self == SoftButtonStyle {
    
    /// A Soft UI style button
    public static var soft: SoftButtonStyle {
        SoftButtonStyle(isAnimated: false)
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
            }
            .buttonStyle(.soft)
            .padding()
            
            if showSecondary {
                Button {
                    
                } label: {
                    Text("Secondary")
                }
                .buttonStyle(.soft.animated())
                .transitionPhaseExposing()
                
                Spacer()
            } else {
                Spacer()
            }
        }
    }
    .colorScheme(.dark)
}
