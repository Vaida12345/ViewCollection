//
//  AnimatedAppearing.swift
//  The Stratum Module
//
//  Created by Vaida on 2023/9/23.
//  Copyright © 2019 - 2024 Vaida. All rights reserved.
//

import SwiftUI


private struct AnimatedAppearView: ViewModifier {
    
    let animation: Animation
    
    @State private var isShown = false
    
    func body(content: Content) -> some View {
        Group {
            if isShown {
                content
            } else {
                content
                    .hidden()
            }
        }
        .onAppear {
            withAnimation(animation) {
                isShown = true
            }
        }
    }
}


public extension View {
    
    /// Marks the introduction of this view as animated.
    ///
    /// > Example:
    /// > ```swift
    /// > Text("Hello")
    /// >     .transition(.slide)
    /// >     .animatedAppearing()
    /// > ```
    ///
    /// - Parameters:
    ///   - animation: The animation used for appearing.
    @available(*, deprecated, message: "Please avoid using this method.")
    func animatedAppearing(_ animation: Animation = .default) -> some View {
        self.modifier(AnimatedAppearView(animation: animation))
    }
    
}


#Preview {
    @Previewable @State var showLabel: Bool = false
    
    Text("Hello")
        .transition(.slide.combined(with: .opacity))
        .modifier(AnimatedAppearView(animation: .default))
        .padding()
}
