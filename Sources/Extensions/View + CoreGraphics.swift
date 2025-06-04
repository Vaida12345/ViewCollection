//
//  View + CoreGraphics.swift
//  ViewCollection
//
//  Created by Vaida on 2025-05-31.
//

import SwiftUI
import CoreGraphics


extension View {
    
    /// Positions this view within an invisible frame with the specified size.
    ///
    /// Use this method to specify a fixed size for a view's width and height.
    ///
    /// - Parameters:
    ///   - size: A fixed width and height for the resulting view.
    ///   - alignment: The alignment of this view inside the resulting frame.
    public func frame(_ size: CGSize, alignment: Alignment = .center) -> some View {
        self.frame(width: size.width, height: size.height, alignment: alignment)
    }
    
    /// Positions this view at the specified rect in its parent's coordinate space.
    ///
    /// This view uses the same coordinate plane as in `CoreGraphics`, with the origin located at the top left corner.
    ///
    /// ```swift
    /// ZStack {
    ///     DebugGridView()
    ///     Rectangle()
    ///         .frame(CGRect(x: 10, y: 10, width: 20, height: 20))
    /// }
    /// .frame(width: 100, height: 100)
    /// ```
    ///
    /// ![Preview](frame)
    ///
    /// - Parameters:
    ///   - rect: The rect position containing the view.
    ///   - alignment: The alignment of this view inside `rect`.
    public func frame(_ rect: CGRect, alignment: Alignment = .center) -> some View {
        self
            .frame(rect.size, alignment: alignment)
            .position(rect.center)
    }
    
}


#Preview {
    ZStack {
        DebugGridView()
        
        Rectangle()
            .frame(CGRect(x: 10, y: 10, width: 20, height: 20))
    }
    .frame(width: 101, height: 101)
    .padding()
}
