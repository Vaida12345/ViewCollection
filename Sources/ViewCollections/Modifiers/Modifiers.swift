//
//  View Modifiers.swift
//
//
//  Created by Vaida on 4/28/24.
//

import Foundation
import SwiftUI


extension View {
    
    /// The `fullScreenCover` for *iPhone* and *Apple Watch*, `sheet` otherwise.
    @inlinable
    @ViewBuilder
    func screenCover<Content>(
        isPresented: Binding<Bool>,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View where Content : View {
#if os(macOS)
        sheet(isPresented: isPresented, onDismiss: onDismiss) {
            content()
        }
#else
        if DesignPattern.current == .phone || DesignPattern.current == .watch {
            fullScreenCover(isPresented: isPresented, onDismiss: onDismiss) {
                content()
            }
        } else {
            sheet(isPresented: isPresented, onDismiss: onDismiss) {
                content()
            }
        }
#endif
    }
    
}
