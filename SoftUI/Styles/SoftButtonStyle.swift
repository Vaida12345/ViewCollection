//
//  SoftButtonStyle.swift
//  ViewCollection
//
//  Created by Vaida on 4/2/25.
//

import SwiftUI


public struct SoftButtonStyle<S: Shape>: ButtonStyle {
    
    let shape: S
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    
    public func makeBody(configuration: Configuration) -> some View {
        let radius = !isEnabled ? 2 : configuration.isPressed ? 1.0 : 4
        
        configuration.label
            .foregroundColor(Color.soft.secondary)
            .background {
                SoftOuterShadow(shape: shape, radius: radius)
                    .animation(.spring.speed(configuration.isPressed ? 4 : 1), value: configuration.isPressed)
            }
            .sensoryFeedback(trigger: configuration.isPressed) { oldValue, newValue in
                    .impact(flexibility: .soft, intensity: newValue ? 1.0 : 0.7)
            }
    }
    
}


extension ButtonStyle where Self == SoftButtonStyle<AnyShape> {
    
    /// A Soft UI style button
    public static func soft<S: Shape>(shape: S) -> SoftButtonStyle<S> {
        SoftButtonStyle(shape: shape)
    }
    
}


#Preview {
    ZStack {
        Color.soft.main.ignoresSafeArea(.all)
        
        Button {
            
        } label: {
            Text("Hit Me!")
                .padding()
        }
        .buttonStyle(.soft(shape: .capsule))
    }
    .colorScheme(.dark)
}
