//
//  SwiftUI.swift
//  ViewCollection
//
//  Created by Vaida on 9/26/24.
//

import SwiftUI

// MARK: - SwiftUI Convenience Initializers

extension GridItem {
    
    /// Creates a single item with the specified fixed size.
    ///
    /// This initializer uses the default parameters for `spacing` and `alignment`.
    ///
    /// - Parameters:
    ///   - size: the specified fixed size.
    public static func fixed(_ size: CGFloat) -> GridItem {
        GridItem(.fixed(size))
    }
    
}
