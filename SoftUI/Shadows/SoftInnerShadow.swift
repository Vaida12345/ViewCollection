//
//  SoftInnerShadow.swift
//  ViewCollection
//
//  Created by Vaida on 4/3/25.
//

import SwiftUI
import ViewCollection


/// The inner shadows building block.
internal struct SoftInnerShadow<S: Shape>: View {
    
    let shape: S
    
    let radius: Double
    
    let foregroundColor: Color
    
    var body: some View {
        ZStack {
            MeshGradient(
                width: 2,
                height: 2,
                points: [
                    [0, 0], [0, 1],
                    [1, 0], [1, 1]
                ],
                colors: [
                    Color.soft.darkShadow,
                    Color.soft.darkShadow
                        .mix(with: .soft.lightShadow, by: 0.5),
                    Color.soft.darkShadow
                        .mix(with: .soft.lightShadow, by: 0.5),
                    Color.soft.lightShadow,
                ]
            )
            
            shape
                .fill(foregroundColor)
                .blur(radius: radius)
                .padding(.all, radius)
        }
        .clipShape(shape)
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
        
        SoftInnerShadow(shape: RoundedRectangle(cornerRadius: 10))
            .frame(width: 120, height: 30)
    }
    .colorScheme(.dark)
}
