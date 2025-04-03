//
//  SoftButtonStyle.swift
//  ViewCollection
//
//  Created by Vaida on 4/2/25.
//

import SwiftUI


public struct SoftButtonStyle<S: Shape>: ButtonStyle {
    
    let background: S
    
    let shadowRadius: CGFloat = 4
    
    let shadowOffset: CGFloat = 4
    
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background {
                background
                    .fill(Color.soft.main)
                    .opacity(1)
                    .shadow(color: .soft.lightShadow, radius: shadowRadius, x: -shadowOffset, y: -shadowOffset)
                    .shadow(color: .soft.darkShadow, radius: shadowRadius, x: shadowOffset, y: shadowOffset)
                    .padding()
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
