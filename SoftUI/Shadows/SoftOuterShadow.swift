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
    
    let radius: Double
    
    let foregroundColor: Color
    
    var body: some View {
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
    
    
    init(shape: S, radius: Double = 4, foregroundColor: Color = .soft.main) {
        self.shape = shape
        self.radius = radius
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
