//
//  softButtonPaddingDisabled.swift
//  ViewCollection
//
//  Created by Vaida on 2025-05-28.
//

import SwiftUI


extension EnvironmentValues {
    @Entry var softButtonPaddingDisabled: Bool = false
}


extension View {
    
    /// Disables the padding defined by soft button style, allowing the user to customize the padding.
    public func softButtonPaddingDisabled(_ disabled: Bool) -> some View {
        environment(\.softButtonPaddingDisabled, disabled)
    }
    
}
