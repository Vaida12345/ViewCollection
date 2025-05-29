//
//  SimpleCircularProgressViewStyle.swift
//  The Stratum Module
//
//  Created by Vaida on 7/31/23.
//  Copyright © 2019 - 2024 Vaida. All rights reserved.
//

import SwiftUI


/// A simple default progress view styles, showing only the `fractionCompleted`.
public struct SimpleCircularProgressViewStyle: ProgressViewStyle {
    
    public func makeBody(configuration: Configuration) -> some View {
        ProgressView(value: configuration.fractionCompleted)
            .progressViewStyle(.circular)
    }
    
}


extension ProgressViewStyle where Self == SimpleCircularProgressViewStyle {
    
    /// A simple circular progress style, without labels.
    @available(*, deprecated, renamed: "circular()", message: "Please use `circular()` instead.")
    public static var simpleCircular: SimpleCircularProgressViewStyle {
        SimpleCircularProgressViewStyle()
    }
    
}
