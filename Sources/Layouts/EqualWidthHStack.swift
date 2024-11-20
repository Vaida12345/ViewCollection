//
//  EqualWidthHStack.swift
//  The Stratum Module
//
//  Created by Vaida on 2024/1/27.
//  Copyright © 2019 - 2024 Vaida. All rights reserved.
//

import SwiftUI
import NativeImage


/// The HStack with equal width for each subview.
///
/// You can optionally add the `frame(maxWidth: .infinity)` property to the subviews, asking it to take the entire horizontal area.
///
/// ```swift
/// ContainerView {
///     EqualWidthHStack {
///         Text("12345")
///             .padding(.horizontal)
///             .frame(maxWidth: .infinity)
///             .background(.red)
///
///         Text("6")
///             .padding(.horizontal)
///             .frame(maxWidth: .infinity)
///             .background(.green)
///     }
///     .background(.blue)
/// }
/// ```
///
/// ![Example View](equalWidthHStack)
public struct EqualWidthHStack: Layout {
    
    private let spacing: Double
    
    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let layout = AnyLayout(HStackLayout(spacing: spacing))
        var cache = layout.makeCache(subviews: subviews)
        return layout.sizeThatFits(proposal: proposal, subviews: subviews, cache: &cache)
    }
    
    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let width = (bounds.width - Double(subviews.count - 1) * spacing) / Double(subviews.count)
        let height = subviews.reduce(0) { max($0, $1.dimensions(in: proposal).height) }
        
        for (index, subview) in subviews.enumerated() {
            subview.place(at: bounds.origin + CGPoint(x: (spacing + width) * Double(index), y: 0), 
                          proposal: .init(width: width, height: height))
        }
    }
    
    public static var layoutProperties: LayoutProperties {
        var property = LayoutProperties()
        property.stackOrientation = .horizontal
        return property
    }
    
    
    /// Creates the HStack.
    ///
    /// - Parameters:
    ///   - spacing: The spacing between adjacent views.
    public init(spacing: Double = 10) {
        self.spacing = spacing
    }
    
}


#Preview {
    EqualWidthHStack {
        Text("12345")
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            .background(.red)
        
        Text("6")
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
            .background(.green)
    }
    .background(.blue)
    .padding()
    .frame(maxWidth: .infinity, maxHeight: .infinity)
}
