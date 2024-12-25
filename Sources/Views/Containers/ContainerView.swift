//
//  ContainerView.swift
//  The ViewCollection Module
//
//  Created by Vaida on 6/2/24.
//  Copyright © 2019 - 2024 Vaida. All rights reserved.
//

import Foundation
import SwiftUI


/// A view that could take up the entire parent view.
///
/// In the following example, the VStack is placed at the center of the parent view.
/// ![Example](equalWidthVStack)
public struct ContainerView<Content: View>: View {
    
    let content: () -> Content
    
    let alignment: Alignment
    
    public var body: some View {
        ZStack(alignment: alignment) {
            Rectangle()
                .fill(.clear)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            content()
        }
    }
    
    /// Creates the container view.
    ///
    /// - Parameters:
    ///   - alignment: The placement for `content`.
    ///   - content: The content view embed in a `ZStack`.
    public init(alignment: Alignment = .center, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.alignment = alignment
    }
    
}


#Preview {
    ContainerView(alignment: .leading) {
        Text("Hello")
    }
}
