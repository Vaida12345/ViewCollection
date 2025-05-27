//
//  SoftOuterShadow.swift
//  ViewCollection
//
//  Created by Vaida on 4/3/25.
//

import SwiftUI
import ViewCollection


/// The inner shadows building block.
internal struct SoftOuterShadow<S: Shape>: View {
    
    let shape: S
    
    @Environment(\.softUIShadowRadius) private var radius
    
    let foregroundColor: Color
    
    var body: some View {
        let radius = radius ?? 4
        
        shape
            .fill(foregroundColor)
            .shadow(
                color: .soft.lightShadow.mix(with: foregroundColor, by: 0.1),
                radius: radius,
                x: -radius,
                y: -radius
            )
            .shadow(color: .soft.darkShadow.mix(with: foregroundColor, by: 0.1), radius: radius, x: radius, y: radius)
    }
    
    
    init(shape: S, foregroundColor: Color = .soft.main) {
        self.shape = shape
        self.foregroundColor = foregroundColor
    }
    
}


#Preview {
    ZStack {
        Color.soft.main.ignoresSafeArea(.all)
        
        SoftOuterShadow(
            shape: RoundedRectangle(cornerRadius: 10),
            foregroundColor: .blue
        )
        .frame(width: 120, height: 40)
    }
    .colorScheme(.dark)
}
