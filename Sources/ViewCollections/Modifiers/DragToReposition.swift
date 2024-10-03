//
//  DragToReposition.swift
//  ViewCollection
//
//  Created by Vaida on 10/4/24.
//

import SwiftUI


extension View {
    
    /// When the view is dragged, reposition the window.
    public func dragToRepositionWindow() -> some View {
        gesture(
            DragGesture()
                .onChanged { value in
                    // Get the current window
                    if let window = NSApplication.shared.windows.first(where: { $0.isKeyWindow }) {
                        // Update window position
                        let newOrigin = CGPoint(
                            x: window.frame.origin.x + value.translation.width,
                            y: window.frame.origin.y - value.translation.height
                        )
                        window.setFrameOrigin(newOrigin)
                    }
                }
        )
    }
    
}
