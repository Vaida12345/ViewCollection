//
//  SoftShadowShape.swift
//  ViewCollection
//
//  Created by Vaida on 2025-05-28.
//

import SwiftUI


extension EnvironmentValues {
    @Entry var softUIShape: AnyShape = AnyShape(.capsule)
}


extension View {
    
    /// specifies the shape of the soft UI.
    public func softUIShape(_ shape: some Shape) -> some View {
        environment(\.softUIShape, AnyShape(shape))
    }
    
}
