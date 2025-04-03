//
//  SoftProgressStyle.swift
//  ViewCollection
//
//  Created by Vaida on 4/3/25.
//

import Essentials
import SwiftUI


struct SoftProgressStyle: ProgressViewStyle {
    
    let foregroundColor: Color
    
    
    func makeBody(configuration: Configuration) -> some View {
        GeometryReader { geometry in
            ZStack {
                Capsule()
                    .fill(.clear)
                    .modifier(
                        SoftInnerShadow(
                            shape: Capsule(),
                            radius: radius
                        )
                    )
                
                Capsule()
                    .fill(foregroundColor.opacity(0.2))
                
                let maxWidth = geometry.size.width - progressPadding * 2
                let minWidth = geometry.size.height - progressPadding * 2
                
                if let fractionCompleted = configuration.fractionCompleted {
                    EmptyView()
                        .modifier(
                            SoftOuterShadow(
                                shape: Capsule(),
                                radius: radius,
                                foregroundColor: foregroundColor
                            )
                        )
                        .padding(.trailing, maxWidth - linear(fractionCompleted, domain: 1, min: minWidth, max: maxWidth))
                        .padding(.all, progressPadding)
                }
            }
        }
        .frame(maxHeight: 30)
    }
    
    init(foregroundColor: Color = .accentColor) {
        self.foregroundColor = foregroundColor
    }
    
    
    var progressPadding: CGFloat {
        radius * 2
    }
    
    let radius: Double = 3
    
    private func linear(_ x: Double, domain: Double, min: Double, max: Double) -> Double {
        let gradient = (max - min) / domain
        return min + gradient * x
    }
    
}


#Preview {
    ZStack {
        Color.soft.main.ignoresSafeArea(.all)
        
        VStack(spacing: 20) {
            ProgressView()
                .progressViewStyle(SoftProgressStyle())
            
            ProgressView(value: 0)
                .progressViewStyle(SoftProgressStyle())
            
            KeyframeAnimator(initialValue: 0.0, repeating: true) { value in
                ProgressView(value: value)
                    .progressViewStyle(SoftProgressStyle())
            } keyframes: { _ in
                KeyframeTrack(\.self) {
                    LinearKeyframe(1.0, duration: 5)
                    LinearKeyframe(0, duration: 5)
                }
            }
            
            ProgressView(value: 1)
                .progressViewStyle(SoftProgressStyle())
        }
        .padding()
    }
}
