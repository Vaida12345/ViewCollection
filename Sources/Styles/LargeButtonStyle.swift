//
//  LargeButtonStyle.swift
//  The Stratum Module
//
//  Created by Vaida on 1/11/23.
//  Copyright © 2019 - 2024 Vaida. All rights reserved.
//

#if os(iOS) || os(macOS)

import SwiftUI
#if os(iOS)
import CoreHaptics
#endif

/// The large button style with the haptic feedback on iOS.
public struct LargeButtonStyle: ButtonStyle {
    
    private let color: Color?
#if os(iOS)
    private let engine = try? CHHapticEngine()
#endif
    
    @State private var startDate = Date()
    
    public func makeBody(configuration: Configuration) -> some View {
#if os(iOS)
        configuration.label
            .font(.headline)
            .padding()
            .frame(maxWidth: .infinity)
            .background(configuration.isPressed ? _color(configuration: configuration).opacity(0.9) : _color(configuration: configuration))
            .cornerRadius(20)
            .foregroundStyle(.white)
            .onChange(of: configuration.isPressed) { _, value in
                if !value && (startDate.distance(to: Date()) < 5) { return }
                if value { self.startDate = Date() }
                
                do {
                    try playHaptic(isPressed: value)
                } catch let error as CHHapticError {
                    guard error.code.rawValue == -4805 else { return }
                    try? engine?.start()
                    try? playHaptic(isPressed: value)
                } catch {  } // consume error
            }
            .onAppear {
                try? engine?.start()
            }
#elseif os(macOS)
        configuration.label
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
            .background(configuration.isPressed ? _color(configuration: configuration).opacity(0.9) : _color(configuration: configuration))
            .cornerRadius(10)
#endif
    }
    
#if os(iOS)
    private func playHaptic(isPressed: Bool) throws {
        if isPressed {
            try engine?.play(pattern: .init(intensity: 1, sharpness: 1))
        } else {
            try engine?.play(pattern: .init(intensity: 0.5, sharpness: 0.5))
        }
    }
#endif
    
    private func _color(configuration: Configuration) -> Color {
        color != nil ? color! : configuration.role == .destructive ? .red : .accentColor
    }
    
    fileprivate init(color: Color? = nil) {
        self.color = color
    }
    
}


extension ButtonStyle where Self == LargeButtonStyle {
    
    /// A large button style, designed for iPhones.
    ///
    /// This view also comes with a haptic feed back.
    ///
    /// - Parameters:
    ///   - color: The background color that occupies most of the view.
    ///
    /// ## Topics
    ///
    /// ### Returned Style
    /// - ``LargeButtonStyle``
    public static func large(color: Color? = nil) -> LargeButtonStyle {
        LargeButtonStyle(color: color)
    }
    
}
#endif
