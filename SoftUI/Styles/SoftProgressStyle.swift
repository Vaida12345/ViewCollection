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
                SoftInnerShadow()
                
                if let fractionCompleted = configuration.fractionCompleted {
                    Capsule()
                        .fill(Color.soft.fill)
                        .frame(width: geometry.size.width * fractionCompleted)
                        .frame(width: geometry.size.width, alignment: .leading)
                        .mask {
                            Capsule()
                        }
                        .animation(.spring, value: fractionCompleted)
                }
            }
            .softShadowRadius(4 * phaseMultiplier)
            .animation(.default, value: phaseMultiplier)
        }
        .frame(maxHeight: 20)
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
    
}


extension ProgressViewStyle where Self == SoftProgressStyle {
    
    /// A Soft UI style progress view.
    public static var soft: SoftProgressStyle {
        soft()
    }
    
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
            
            ProgressView(value: showProgress ? 0 : 1)
            
            ProgressView(value: 1)
            
            Toggle(isOn: $showProgress) {
                Text("Progress")
            }
            .toggleStyle(.soft(.indicator))
        }
        .padding()
        .progressViewStyle(.soft)
        .softUIShape(.rect(cornerRadius: 10))
    }
    .colorScheme(.dark)
}
