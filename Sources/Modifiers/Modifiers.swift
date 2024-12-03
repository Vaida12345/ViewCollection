//
//  View Modifiers.swift
//
//
//  Created by Vaida on 4/28/24.
//

import Foundation
import SwiftUI


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


