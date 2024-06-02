//
//  ContainerView.swift
//
//
//  Created by Vaida on 6/2/24.
//

import Foundation
import SwiftUI


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
