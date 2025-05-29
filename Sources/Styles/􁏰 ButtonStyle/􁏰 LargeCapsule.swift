//
//  LargeButtonStyle.swift
//  The Stratum Module
//
//  Created by Vaida on 1/11/23.
//  Copyright © 2019 - 2024 Vaida. All rights reserved.
//

import SwiftUI
import CoreHaptics

/// The large button style with the haptic feedback on iOS.
///
/// ![Preview](LargeCapsuleButtonStyle)
@available(iOS 17, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public struct LargeCapsuleButtonStyle: ButtonStyle {
    
    @Environment(\.keyboardShortcut) private var keyboardShortcut
    @Environment(\.colorScheme) private var colorScheme
    
    let color: Color?
    
    
    private func foregroundColor(for configuration: Configuration) -> Color {
        if let color {
            let components = color.animatableData
            let max = [components[0] * components[3], components[1] * components[3], components[2] * components[3]].mean!
            if max >= 0.65 {
                return Color.black
            } else {
                return Color.white
            }
        } else {
            if keyboardShortcut == .defaultAction || configuration.role == .destructive {
                return Color.white
            } else if colorScheme == .light {
                return Color.black
            } else {
                return Color.white
            }
        }
    }
    
    private func backgroundColor(for configuration: Configuration) -> Color {
        if let color {
            color
        } else {
            switch colorScheme {
            case .light:
                if keyboardShortcut == .defaultAction {
                    Color(red: 2 / 255, green: 123 / 255, blue: 1)
                } else if configuration.role == .destructive {
                    Color.red
                } else {
                    Color.white
                }
            case .dark:
                if keyboardShortcut == .defaultAction {
                    Color(red: 22 / 255, green: 95 / 255, blue: 208 / 255)
                } else if configuration.role == .destructive {
                    Color.red
                } else {
                    Color(white: 94 / 255)
                }
            @unknown default:
                fatalError()
            }
        }
    }
    
    private func maskColor(for configuration: Configuration) -> Color {
        switch colorScheme {
        case .light:
            Color.black.opacity(0.1)
        case .dark:
            Color.white.opacity(0.1)
        @unknown default:
            fatalError()
        }
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(foregroundColor(for: configuration))
            .padding()
            .frame(maxWidth: .infinity)
            .background(configuration.isPressed ? maskColor(for: configuration) : Color.clear, in: RoundedRectangle(cornerRadius: 20))
            .background(backgroundColor(for: configuration), in: RoundedRectangle(cornerRadius: 20))
            .compositingGroup()
            .shadow(radius: configuration.isPressed ? 1.5 : 2)
            .sensoryFeedback(.selection, trigger: configuration.isPressed)
    }
    
}


@available(iOS 17, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension ButtonStyle where Self == LargeCapsuleButtonStyle {
    
    /// The large button style with the haptic feedback on iOS.
    ///
    /// ![Preview](LargeCapsuleButtonStyle)
    public static var largeCapsule: LargeCapsuleButtonStyle {
        largeCapsule()
    }
    
    /// The large button style with the haptic feedback on iOS.
    ///
    /// ![Preview](LargeCapsuleButtonStyle)
    public static func largeCapsule(color: Color? = nil) -> LargeCapsuleButtonStyle {
        LargeCapsuleButtonStyle(color: color)
    }
    
}

#if os(iOS)
#Preview {
    ScrollView {
        VStack {
            Spacer()
            
            ForEach(Color.allColors) { color in
                Button("Hello") {
                    
                }
                .buttonStyle(.largeCapsule(color: color))
                .padding()
            }
        }
    }
}
#endif
