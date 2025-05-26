//
//  CircularButtonStyle.swift
//  ViewCollection
//
//  Created by Vaida on 12/31/24.
//

import SwiftUI


public struct LargeControlButtonStyle: ButtonStyle {
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .symbolVariant(.fill)
            .foregroundStyle(.regularMaterial)
            .shadow(radius: 1)
            .fontWeight(.semibold)
            .imageScale(.large)
            .transformEnvironment(\.colorScheme) {
                $0 = $0 == .dark ? .light : .dark
            }
            .shadow(radius: configuration.isPressed ? 0.5 : 1)
            .scaleEffect(configuration.isPressed ? 1.3 : 1.4)
            .opacity(configuration.isPressed ? 0.5 : 1)
            .animation(.spring.speed(2), value: configuration.isPressed)
    }
}


extension ButtonStyle where Self == LargeControlButtonStyle {
    
    /// A large control button style.
    public static var largeControl: LargeControlButtonStyle {
        LargeControlButtonStyle()
    }
    
}


#Preview {
    Button {
        
    } label: {
        Image(systemName: "play")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 40)
    }
    .buttonStyle(.largeControl)
    .padding()
}
