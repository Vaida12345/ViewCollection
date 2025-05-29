//
//  SoftOuterShadow.swift
//  ViewCollection
//
//  Created by Vaida on 4/3/25.
//

import SwiftUI
import ViewCollection


/// The outer shadows building block.
///
/// ```swift
/// Text("12345")
///     .padding()
///     .background(SoftOuterShadow())
/// ```
///
/// ![Preview](SoftOuterShadow)
public struct SoftOuterShadow: View {
    
    @Environment(\.softUIShape) private var shape
    @Environment(\.softUIShadowRadius) private var radius
    
    let foregroundColor: Color
    
    public var body: some View {
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
    
    
    public init(foregroundColor: Color = .soft.main) {
        self.foregroundColor = foregroundColor
    }
    
}


#Preview {
    ZStack {
        Color.soft.main.ignoresSafeArea(.all)
        
        Text("12345")
            .padding()
            .padding(.horizontal)
            .background(SoftOuterShadow())
    }
    .colorScheme(.dark)
}
