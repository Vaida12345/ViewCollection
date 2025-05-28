//
//  SoftOuterShadowBackground.swift
//  ViewCollection
//
//  Created by Vaida on 4/3/25.
//

import SwiftUI
import ViewCollection


/// The inner shadows building block.
public struct SoftOuterShadowBackground: ViewModifier {
    
    @Environment(\.softUIShape) private var shape
    @Environment(\.softUIShadowRadius) private var radius
    
    let foregroundColor: Color
    
    public func body(content: Content) -> some View {
        let radius = radius ?? 4
        
        content
            .foregroundStyle(foregroundColor)
            .shadow(
                color: .soft.lightShadow.mix(with: foregroundColor, by: 0.1),
                radius: radius,
                x: -radius,
                y: -radius
            )
            .shadow(color: .soft.darkShadow.mix(with: foregroundColor, by: 0.1), radius: radius, x: radius, y: radius)
    }
    
    
    public init(foregroundColor: Color = .soft.secondary) {
        self.foregroundColor = foregroundColor
    }
    
}


#Preview {
    ZStack {
        Color.soft.main.ignoresSafeArea(.all)
        
        Image(systemName: "play.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 20)
            .padding()
            .modifier(SoftOuterShadowBackground())
    }
    .colorScheme(.dark)
}
