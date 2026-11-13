//
//  CircularButtonStyle.swift
//  ViewCollection
//
//  Created by Vaida on 12/31/24.
//

import SwiftUI


/// A circular button style.
///
/// The button material is always the opposite of foregroundColor.
///
/// ![preview](floatingSheet)
public struct CircularFillButtonStyle: ButtonStyle {
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .symbolVariant(.circle)
            .symbolVariant(.fill)
            .foregroundStyle(.thinMaterial)
            .fontWeight(.semibold)
            .imageScale(.large)
            .transformEnvironment(\.colorScheme) {
                $0 = $0 == .dark ? .light : .dark
            }
            .scaleEffect(configuration.isPressed ? 1.3 : 1.4)
            .opacity(configuration.isPressed ? 0.5 : 1)
            .animation(.spring.speed(2), value: configuration.isPressed)
    }
}


extension ButtonStyle where Self == CircularFillButtonStyle {
    
    /// A circular button style.
    ///
    /// The button material is always the opposite of foregroundColor.
    ///
    /// ![preview](floatingSheet)
    @available(*, deprecated, renamed: "circularFill")
    public static var circular: CircularFillButtonStyle {
        CircularFillButtonStyle()
    }
    
    /// A circular button style.
    ///
    /// The button material is always the opposite of foregroundColor.
    ///
    /// ![preview](floatingSheet)
    public static var circularFill: CircularFillButtonStyle {
        CircularFillButtonStyle()
    }
    
}


#if os(iOS) || os(visionOS)
#Preview {
    Button {
        
    } label: {
        Image(systemName: "xmark")
    }
    .buttonStyle(.circularFill)
    .padding()
}
#endif
