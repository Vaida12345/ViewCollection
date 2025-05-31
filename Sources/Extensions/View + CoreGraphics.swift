//
//  View + CoreGraphics.swift
//  ViewCollection
//
//  Created by Vaida on 2025-05-31.
//

import SwiftUICore
import CoreGraphics


extension View {
    
    public func frame(_ size: CGSize, alignment: Alignment) -> some View {
        self.frame(width: size.width, height: size.height, alignment: alignment)
    }
    
    public func frame(_ frame: CGRect, alignment: Alignment) -> some View {
        self
            .position(frame.origin)
            .frame(frame.size, alignment: alignment)
    }
    
}
