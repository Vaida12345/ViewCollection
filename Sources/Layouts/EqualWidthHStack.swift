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
    
    /// Returns the size needed to give every subview the same width.
    ///
    /// When a finite width is proposed, that width is divided equally between the
    /// subviews after spacing is reserved. Otherwise, the widest ideal subview is
    /// used as the width for every slot.
    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        guard !subviews.isEmpty else { return .zero }
        
        let spacing = CGFloat(self.spacing)
        let spacingWidth = spacing * CGFloat(subviews.count - 1)
        let itemWidth: CGFloat
        let totalWidth: CGFloat
        
        if let proposedWidth = proposal.width {
            itemWidth = max(0, (proposedWidth - spacingWidth) / CGFloat(subviews.count))
            totalWidth = proposedWidth
        } else {
            itemWidth = subviews.reduce(0) { width, subview in
                max(width, subview.dimensions(in: .init(width: nil, height: proposal.height)).width)
            }
            totalWidth = itemWidth * CGFloat(subviews.count) + spacingWidth
        }
        
        let height = subviews.reduce(0) { height, subview in
            max(height, subview.dimensions(in: .init(width: itemWidth, height: proposal.height)).height)
        }
        
        return CGSize(width: max(0, totalWidth), height: height)
    }
    
    /// Places each subview in an equal-width horizontal slot within the available bounds.
    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        guard !subviews.isEmpty else { return }
        
        let spacing = CGFloat(self.spacing)
        let width = max(0, (bounds.width - CGFloat(subviews.count - 1) * spacing) / CGFloat(subviews.count))
        let placementProposal = ProposedViewSize(width: width, height: bounds.height)
        
        for (index, subview) in subviews.enumerated() {
            subview.place(at: bounds.origin + CGPoint(x: (spacing + width) * CGFloat(index), y: 0),
                          proposal: placementProposal)
        }
    }
    
    /// Describes this layout as a horizontal stack for SwiftUI spacer behavior.
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
