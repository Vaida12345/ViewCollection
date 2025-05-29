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
@available(iOS 17, *)
@available(visionOS 1, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct CircularFillButtonStyle: ButtonStyle {
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .symbolVariant(.circle)
            .symbolVariant(.fill)
            .foregroundStyle(.regularMaterial)
            .shadow(radius: 1)
            .fontWeight(.semibold)
            .imageScale(.large)
            .transformEnvironment(\.colorScheme) {
                $0 = $0 == .dark ? .light : .dark
            }
            .shadow(radius: configuration.isPressed ? 0.5 : 1)
            .scaleEffect(configuration.isPressed ? 1.3 : 1.4)
            .opacity(configuration.isPressed ? 0.5 : 1)
            .animation(.spring.speed(2), value: configuration.isPressed)
    }
}


@available(iOS 17, *)
@available(visionOS 1, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
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
    .buttonStyle(.circular)
    .padding()
}
#endif
