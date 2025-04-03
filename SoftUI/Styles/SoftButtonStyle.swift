//
//  SoftButtonStyle.swift
//  ViewCollection
//
//  Created by Vaida on 4/2/25.
//

import SwiftUI


public struct SoftButtonStyle<S: Shape>: ButtonStyle {
    
    let background: S
    
    
    public func makeBody(configuration: Configuration) -> some View {
        let radius = configuration.isPressed ? 1.0 : 4
        
        configuration.label
            .modifier(SoftOuterShadow(shape: background, radius: radius))
            .transaction { transaction in
                if configuration.isPressed {
                    transaction.animation = .spring.speed(4)
                } else {
                    transaction.animation = .spring
                }
            }
    }
    
}


#Preview {
    ZStack {
        Color(red: 0.925, green: 0.941, blue: 0.953)
            .ignoresSafeArea(.all)
        
        Button {
            
        } label: {
            Text("         ")
                .padding()
        }
        .buttonStyle(SoftButtonStyle(background: .rect(cornerRadius: 10)))
        .frame(width: 120, height: 60)
    }
}
