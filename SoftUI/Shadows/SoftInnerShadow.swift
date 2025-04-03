//
//  SoftInnerShadow.swift
//  ViewCollection
//
//  Created by Vaida on 4/3/25.
//

import SwiftUI
import ViewCollection


/// The inner shadows building block.
internal struct SoftInnerShadow<S: Shape>: ViewModifier {
    
    let shape: S
    
    let radius: Double
    
    func body(content: Content) -> some View {
        ZStack {
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
                    .fill(Color.soft.main)
                    .blur(radius: radius)
                    .padding(.all, radius)
            }
            .clipShape(shape)
            
            content
                .foregroundStyle(Color.soft.secondary)
        }
    }
    
    
    init(shape: S, radius: Double = 4) {
        self.shape = shape
        self.radius = radius
    }
    
}


#Preview {
    ZStack {
        Color.soft.main.ignoresSafeArea(.all)
        
        Text("123")
            .modifier(SoftInnerShadow(shape: RoundedRectangle(cornerRadius: 10)))
            .frame(width: 120, height: 30)
    }
}
