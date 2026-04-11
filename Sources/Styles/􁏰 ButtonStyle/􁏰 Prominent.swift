//
//  Prominent.swift
//  ViewCollection
//
//  Created by Vaida on 2026-04-11.
//

import SwiftUI

public struct ProminentButtonStyle: PrimitiveButtonStyle {
    
    public func makeBody(configuration: Configuration) -> some View {
        #if !os(visionOS)
        if #available(macOS 26, iOS 26, macCatalyst 26, watchOS 26, tvOS 26, *) {
            GlassProminentButtonStyle().makeBody(configuration: configuration)
        } else {
            BorderedProminentButtonStyle().makeBody(configuration: configuration)
        }
        #else
        BorderedProminentButtonStyle().makeBody(configuration: configuration)
        #endif
    }
}


extension PrimitiveButtonStyle where Self == ProminentButtonStyle {
    
    /// The most suitable prominent style.
    ///
    /// On pre OS 26 devices, returns `borderedProminent`, otherwise `glassProminent`.
    public static var prominent: ProminentButtonStyle {
        ProminentButtonStyle()
    }
    
}


#Preview {
    Button("Hello") {
        
    }
    .buttonStyle(.prominent)
}
