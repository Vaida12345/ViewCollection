//
//  WideBorderedButtonStyle.swift
//  ViewCollection
//
//  Created by Vaida on 12/30/24.
//

import SwiftUI


public struct WideBorderedButtonStyle: ButtonStyle {
    
    @Environment(\.keyboardShortcut) private var keyboardShortcut
    @Environment(\.colorScheme) private var colorScheme
    
    private func foregroundColor(for configuration: Configuration) -> Color {
        if keyboardShortcut == .defaultAction || configuration.role == .destructive {
            Color.white
        } else if colorScheme == .light {
            Color.black
        } else {
            Color.white
        }
    }
    
    private func backgroundColor(for configuration: Configuration) -> Color {
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
            .foregroundStyle(foregroundColor(for: configuration))
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .background(configuration.isPressed ? maskColor(for: configuration) : Color.clear)
            .background(backgroundColor(for: configuration), in: RoundedRectangle(cornerRadius: 5))
            .compositingGroup()
            .shadow(radius: configuration.isPressed ? 1.5 : 2)
    }
}


extension ButtonStyle where Self == WideBorderedButtonStyle {
    
    /// A large button style, designed for macOS.
    ///
    /// ## Topics
    ///
    /// ### Returned Style
    /// - ``WideBorderedButtonStyle``
    public static var borderedWide: WideBorderedButtonStyle {
        WideBorderedButtonStyle()
    }
    
}


#Preview {
    Button("Hello") {
        
    }
    .buttonStyle(.borderedWide)
    .padding()
}

#Preview {
    Button("Hell o", role: .destructive) {
        
    }
    .padding()
}
