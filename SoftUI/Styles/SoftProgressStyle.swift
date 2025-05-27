//
//  SoftProgressStyle.swift
//  ViewCollection
//
//  Created by Vaida on 4/3/25.
//

import Essentials
import SwiftUI


public struct SoftProgressStyle: ProgressViewStyle {
    
    let foregroundColor: Color
    @Environment(\.transitionPhase) private var transitionPhase
    
    let isAnimated: Bool
    
    var phaseMultiplier: Double {
        guard let transitionPhase else { return isAnimated ? 0 : 1 }
        return transitionPhase == .identity ? 1 : 0
    }
    
    
    public func makeBody(configuration: Configuration) -> some View {
        GeometryReader { geometry in
            ZStack {
                SoftInnerShadow(shape: Capsule())
                
                let maxWidth = geometry.size.width - progressPadding * 2
                let minWidth = geometry.size.height - progressPadding * 2
                
                if let fractionCompleted = configuration.fractionCompleted {
                    SoftOuterShadow(
                        shape: Capsule(),
                        foregroundColor: foregroundColor
                    )
                    .padding(.trailing, maxWidth - linear(fractionCompleted, domain: 1, min: minWidth, max: maxWidth))
                    .padding(.all, progressPadding)
                }
            }
            .softShadowRadius(radius * phaseMultiplier)
            .animation(.default, value: phaseMultiplier)
        }
        .frame(maxHeight: 30)
    }
    
    /// Indicates that transitions should be shown on view appear.
    ///
    /// > Warning: When `animated`, the view must attach `transitionPhaseExposing()`
    /// > ```swift
    /// > ProgressView(...)
    /// >     .progressViewStyle(.soft().animated())
    /// >     .transitionPhaseExposing()
    /// > ```
    public func animated(_ animated: Bool = true) -> SoftProgressStyle {
        SoftProgressStyle(foregroundColor: foregroundColor, isAnimated: animated)
    }
    
    
    var progressPadding: CGFloat {
        radius * 2
    }
    
    let radius: Double = 4
    
    private func linear(_ x: Double, domain: Double, min: Double, max: Double) -> Double {
        let gradient = (max - min) / domain
        return min + gradient * x
    }
    
}


extension ProgressViewStyle where Self == SoftProgressStyle {
    
    /// A Soft UI style progress view.
    public static func soft(foregroundColor: Color = .accentColor) -> SoftProgressStyle {
        SoftProgressStyle(foregroundColor: foregroundColor, isAnimated: false)
    }
    
}


#Preview {
    @Previewable @State var showProgress = false
    
    ZStack {
        Color.soft.main.ignoresSafeArea(.all)
        
        VStack(spacing: 20) {
            if showProgress {
                ProgressView()
                    .progressViewStyle(.soft().animated())
                    .transitionPhaseExposing()
            } else {
                ProgressView()
                    .hidden()
            }
            
            ProgressView(value: 0)
            
            KeyframeAnimator(initialValue: 0.0, repeating: true) { value in
                ProgressView(value: value)
            } keyframes: { _ in
                KeyframeTrack(\.self) {
                    LinearKeyframe(1.0, duration: 5)
                    LinearKeyframe(0, duration: 5)
                }
            }
            
            ProgressView(value: 1)
            
            Toggle(isOn: $showProgress) {
                Text("Progress")
            }
            .toggleStyle(.soft(.indicator, shape: .rect(cornerRadius: 10)))
        }
        .padding()
        .progressViewStyle(.soft())
    }
    .colorScheme(.dark)
}
