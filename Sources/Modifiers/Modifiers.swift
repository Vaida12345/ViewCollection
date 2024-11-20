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
    public func screenCover<Content>(
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

public extension View {
    
    /// Applies a conditional modifier to the given view.
    @inlinable
    @ViewBuilder
    func modifier<ModifiedView>(enabled: Bool, @ViewBuilder content: (Self) -> ModifiedView) -> some View where ModifiedView: View {
        if enabled {
            content(self)
        } else {
            self
        }
    }
    
    /// Applies a conditional modifier to the given view.
    @inlinable
    @ViewBuilder
    func modifier<ModifiedView, ElseModifiedView>(enabled: Bool, @ViewBuilder content: (Self) -> ModifiedView, @ViewBuilder else elseContent: (Self) -> ElseModifiedView) -> some View where ModifiedView: View, ElseModifiedView: View {
        if enabled {
            content(self)
        } else {
            elseContent(self)
        }
    }
    
}


