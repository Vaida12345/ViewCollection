//
//  DismissButton.swift
//  ViewCollection
//
//  Created by Vaida on 2026-11-14.
//

import SwiftUI
import Essentials


/// A general purpose dismiss button.
///
/// Use it in situations where a toolbar item is not suitable.
///
/// ```swift
///.overlay(alignment: .topLeading) {
///     DismissButton {
///         ...
///     }
///     .keyboardShortcut(.escape, modifiers: [])
/// }
/// ```
@available(*, deprecated, message: "Use toolbar item instead.")
public struct DismissButton: View {
    
    let action: @MainActor () -> Void
    
    public var body: some View {
        Button(action: action) {
            Label(LocalizedStringResource("Close", bundle: #bundle), systemImage: "xmark")
                .labelStyle(.iconOnly)
#if os(iOS)
                .scaleEffect(1.4)
#else
                .scaleEffect(1.2)
#endif
        }
        .controlSize(.extraLarge)
        .modifier(ButtonStyleModifier())
        .buttonBorderShape(.circle)
#if os(macOS)
        .padding(.all, 10)
#else
        .modifier(ButtonPaddingModifier())
        .modifier(ConditionalIgnoreSafeAreaModifier())
#endif
    }
    
    public init(action: @escaping @MainActor () -> Void) {
        self.action = action
    }
    
}

private struct ButtonStyleModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        if #available(iOS 26, macOS 26, visionOS 26, *) {
            content
                .buttonStyle(.glass)
        } else {
            content
                .buttonStyle(FillButtonStyle())
        }
    }
}

private struct ButtonPaddingModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            if #available(iOS 26, macOS 26, visionOS 26, *) {
                var leadingPadding: CGFloat {
                    geometry.containerCornerInsets.topLeading.width - 25 // button radius
                }
                var topPadding: CGFloat {
                    geometry.containerCornerInsets.topLeading.height - 25
                }
                
                content
                    .padding(.leading, clamp(leadingPadding, min: 10, max: 30))
                    .padding(.top, clamp(topPadding, min: 10, max: 30))
            } else {
                content
                    .padding(.all, 20)
            }
        }
    }
}

private struct ConditionalIgnoreSafeAreaModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        if #available(iOS 26, macOS 26, visionOS 26, *) {
            content.ignoresSafeArea()
        } else {
            content
        }
    }
}

private struct FillButtonStyle: ButtonStyle {
    
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
            .scaleEffect(configuration.isPressed ? 1.175 : 1.2)
            .opacity(configuration.isPressed ? 0.5 : 1)
            .animation(.spring.speed(4), value: configuration.isPressed)
    }
}


#if DEBUG
#Preview {
    Text(verbatim: "Hello")
        .padding()
#if os(macOS)
        .frame(width: 600, height: 300)
        .windowButtons(hiding: [.closeButton, .miniaturizeButton, .zoomButton])
#else
        .frame(maxWidth: .infinity, maxHeight: .infinity)
#endif
        .overlay(alignment: .topLeading) {
            DismissButton {
                
            }
        }
}

#Preview {
    PreviewSheet {
        Text(verbatim: "Hello")
            .padding()
#if os(macOS)
            .frame(width: 600, height: 300)
            .windowButtons(hiding: [.closeButton, .miniaturizeButton, .zoomButton])
#else
            .frame(maxWidth: .infinity, maxHeight: .infinity)
#endif
            .overlay(alignment: .topLeading) {
                DismissButton {
                    
                }
            }
    }
}

#Preview {
    NavigationStack {
        Text("123")
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button {
                        
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
#if os(macOS)
            .frame(width: 600, height: 300)
            .windowButtons(hiding: [.closeButton, .miniaturizeButton, .zoomButton])
#endif
    }
}
#endif
