//
//  FixedPresentationSizing.swift
//  ViewCollection
//
//  Created by Vaida on 2026-11-19.
//

import SwiftUI


/// A presentation sizing that always returns a fixed proposed size for the sheets.
public struct FixedPresentationSizing: PresentationSizing {
    
    let width: CGFloat?
    let height: CGFloat?
    
    public func proposedSize(
        for root: PresentationSizingRoot,
        context: PresentationSizingContext
    ) -> ProposedViewSize {
        ProposedViewSize(width: width, height: height)
    }
    
}


extension PresentationSizing where Self == FixedPresentationSizing {
    
    /// A presentation sizing that always returns a fixed specified size for the sheets.
    public static func fixed(width: CGFloat? = nil, height: CGFloat? = nil) -> FixedPresentationSizing {
        FixedPresentationSizing(width: width, height: height)
    }
    
}


#Preview {
    PreviewSheet {
        Text("12345")
            .padding()
            .presentationSizing(.fixed(width: 100, height: 100))
    }
}
