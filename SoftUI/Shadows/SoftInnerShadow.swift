//
//  SoftInnerShadow.swift
//  ViewCollection
//
//  Created by Vaida on 4/3/25.
//

import SwiftUI
import ViewCollection


/// The inner shadows building block.
internal struct SoftInnerShadow: View {
    
    @Environment(\.softUIShape) private var shape
    @Environment(\.softUIShadowRadius) private var radius
    
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
                .blur(radius: radius ?? 4)
                .padding(.all, radius ?? 4)
        }
        .clipShape(shape)
    }
    
    
    init(foregroundColor: Color = .soft.main) {
        self.foregroundColor = foregroundColor
    }
    
}


#Preview {
    @Previewable @State var progress = 1.0
    
    ZStack {
        Color.soft.main.ignoresSafeArea(.all)
        
        VStack {
            SoftInnerShadow()
                .frame(width: 120, height: 30)
                .softShadowRadius(4 * progress)
            
            Slider(value: $progress)
        }
    }
    .colorScheme(.dark)
}
