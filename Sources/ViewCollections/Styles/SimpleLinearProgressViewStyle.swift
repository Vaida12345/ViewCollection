//
//  SimpleLinearProgressViewStyle.swift
//  The Stratum Module
//
//  Created by Vaida on 7/31/23.
//  Copyright © 2019 - 2024 Vaida. All rights reserved.
//


import SwiftUI


/// A simple default progress view styles, showing only the `fractionCompleted`.
public struct SimpleLinearProgressViewStyle: ProgressViewStyle {
    
    public func makeBody(configuration: Configuration) -> some View {
        ProgressView(value: configuration.fractionCompleted)
            .progressViewStyle(.linear)
    }
    
}


extension ProgressViewStyle where Self == SimpleLinearProgressViewStyle {
    
    /// A simple linear progress style, without labels.
    public static var simpleLinear: SimpleLinearProgressViewStyle {
        SimpleLinearProgressViewStyle()
    }
    
}
