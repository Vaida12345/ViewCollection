//
//  SimpleLinearProgressViewStyle.swift
//  The Stratum Module
//
//  Created by Vaida on 7/31/23.
//  Copyright © 2019 - 2024 Vaida. All rights reserved.
//

import SwiftUI


/// A simple default progress view styles, showing only the `fractionCompleted`.
public struct HeavyProgressViewStyle: ProgressViewStyle {
    
    public func makeBody(configuration: Configuration) -> some View {
        GeometryReader { geometry in
            ZStack {
                Capsule()
                    .fill(.ultraThinMaterial)
                    .frame(height: 10)
#if os(iOS)
                    .shadow(radius: 10)
#endif
                
                if let offset = configuration.fractionCompleted.map({ geometry.size.width * $0 }) {
                    Capsule()
                        .fill(.white)
                        .frame(width: offset, height: 10)
                        .position(x: offset / 2, y: geometry.size.height / 2)
                        .mask {
                            Capsule()
                                .frame(height: 10)
                                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                        }
                        .animation(.spring, value: offset)
                }
            }
        }
        .frame(height: 10)
        .transformEnvironment(\.colorScheme) {
            $0 = $0 == .dark ? .light : .dark
        }
    }
    
}


extension ProgressViewStyle where Self == HeavyProgressViewStyle {
    
    /// A heavy progress style, without labels.
    ///
    /// ## Topics
    ///
    /// ### Returned Style
    /// - ``HeavyProgressViewStyle``
    public static var heavy: HeavyProgressViewStyle {
        HeavyProgressViewStyle()
    }
    
}


#Preview {
    @Previewable @State var progress: Double = 0.0
    
    VStack {
        ProgressView(value: progress)
            .progressViewStyle(.heavy)
        
        Slider(value: $progress)
    }
    .padding()
}
