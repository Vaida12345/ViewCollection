//
//  InnerShadow.swift
//  ViewCollection
//
//  Created by Vaida on 4/3/25.
//

import SwiftUI
import ViewCollection


/// The inner shadows building block.
@available(iOS 18.0, *)
struct InnerShadow<S: Shape>: ViewModifier {
    
    let shape: S
    
    func body(content: Content) -> some View {
        content
            .foregroundStyle(Color.soft.secondary)
            .padding()
            .background {
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
                                .mix(with: .soft.lightShadow, by: 0.7),
                            Color.soft.darkShadow
                                .mix(with: .soft.lightShadow, by: 0.7),
                            Color.soft.lightShadow,
                        ]
                    )
                    
                    shape
                        .fill(Color.soft.main)
                        .blur(radius: 4)
                        .padding(.all, 4)
                }
                .clipShape(shape)
            }
    }
    
}


#Preview {
    ZStack {
        Color.soft.main.ignoresSafeArea(.all)
        
        if #available(iOS 18.0, *) {
            Text("123")
                .modifier(InnerShadow(shape: RoundedRectangle(cornerRadius: 10)))
                .frame(width: 120, height: 60)
        } else {
            // Fallback on earlier versions
        }
    }
}
