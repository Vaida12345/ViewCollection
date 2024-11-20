//
//  AnimatedAppearing.swift
//  The Stratum Module
//
//  Created by Vaida on 2023/9/23.
//  Copyright © 2019 - 2024 Vaida. All rights reserved.
//

import SwiftUI


private struct AnimatedAppearView<Content>: View where Content: View {
    
    let view: Content
    
    let animation: Animation
    
    @State private var isShown = false
    
    var body: some View {
        Group {
            if isShown {
                view
            } else {
                view
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
    func animatedAppearing(_ animation: Animation = .default) -> some View {
        AnimatedAppearView(view: self, animation: animation)
    }
    
}
