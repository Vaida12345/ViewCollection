//
//  EqualWidthVStack.swift
//  The Stratum Module
//
//  Created by Vaida on 2024/1/27.
//  Copyright © 2019 - 2024 Vaida. All rights reserved.
//

import SwiftUI
import NativeImage


/// The VStack with equal width for each subview.
///
/// You can optionally add the `frame(maxWidth: .infinity)` property to the subviews, asking it to take the entire horizontal area.
///
/// ```swift
///  ContainerView {
///     EqualWidthVStack {
///         Text("12345")
///             .frame(maxWidth: .infinity)
///             .padding(.horizontal)
///             .background(.red)
///
///         Text("6")
///             .frame(maxWidth: .infinity)
///             .padding(.horizontal)
///             .background(.green)
///     }
///     .background(.blue)
/// }
/// ```
///
/// ![Example View](equalWidthVStack)
public struct EqualWidthVStack: Layout {
    
    private let spacing: Double
    
    /// Returns the size needed to give every subview the same width.
    ///
    /// When a finite width is proposed, that width is used for every subview.
    /// Otherwise, the widest ideal subview is used as the shared width.
    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        guard !subviews.isEmpty else { return .zero }
        
        let spacing = CGFloat(self.spacing)
        let width: CGFloat
        
        if let proposedWidth = proposal.width, proposedWidth.isFinite {
            width = max(0, proposedWidth)
        } else {
            width = subviews.reduce(0) { width, subview in
                max(width, subview.dimensions(in: .init(width: nil, height: proposal.height)).width)
            }
        }
        
        let height = subviews.reduce(0) { height, subview in
            height + subview.dimensions(in: .init(width: width, height: nil)).height
        }
        let spacingHeight = spacing * CGFloat(subviews.count - 1)
        
        return CGSize(width: max(0, width), height: max(0, height + spacingHeight))
    }
    
    /// Places each subview in an equal-width vertical slot within the available bounds.
    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        guard !subviews.isEmpty else { return }
        
        let spacing = CGFloat(self.spacing)
        let width = bounds.width.isFinite ? max(0, bounds.width) : 0
        var y = bounds.minY
        
        for subview in subviews {
            let height = subview.dimensions(in: .init(width: width, height: nil)).height
            subview.place(at: CGPoint(x: bounds.minX, y: y),
                          proposal: .init(width: width, height: height))
            y += height + spacing
        }
    }
    
    /// Describes this layout as a vertical stack for SwiftUI spacer behavior.
    public static var layoutProperties: LayoutProperties {
        var property = LayoutProperties()
        property.stackOrientation = .vertical
        return property
    }
    
    
    /// Creates the VStack.
    ///
    /// - Parameters:
    ///   - spacing: The spacing between adjacent views.
    public init(spacing: Double = 10) {
        self.spacing = spacing
    }
    
}


#Preview {
    EqualWidthVStack {
        Text("12345")
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            .background(.red)
        
        Text("6")
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            .background(.green)
    }
    .background(.blue)
    .padding()
    .frame(maxWidth: .infinity, maxHeight: .infinity)
}
