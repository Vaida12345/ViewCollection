//
//  SoftShadowRadius.swift
//  ViewCollection
//
//  Created by Vaida on 2025-05-28.
//

import SwiftUI


extension EnvironmentValues {
    @Entry var softUIShadowRadius: Double? = nil
}


extension View {
    
    public func softShadowRadius(_ radius: Double?) -> some View {
        environment(\.softUIShadowRadius, radius)
    }
    
}
