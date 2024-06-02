//
//  FilledVGrid.swift
//  The Stratum Module
//
//  Created by Vaida on 6/16/23.
//  Copyright © 2019 - 2024 Vaida. All rights reserved.
//


import SwiftUI
import Stratum


/// The grid that puts every cell, ideally of equal size, in order.
///
/// A row would be automatically created when the last row cannot fit any more of cells.
///
/// ```swift
/// FilledVGrid {
///     ForEach(colors) { color in
///         ColorView(of: color)
///     }
/// }
/// ```
///
/// ![Color Palette](orangePalette)
public struct FilledVGrid: Layout {
    
    private let spacing: Spacing
    
    
    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        guard !subviews.isEmpty else { return .zero }
        
        if let proposedWidth = proposal.width, proposal.width != 0 {
            let averageHeight = subviews.map { $0.dimensions(in: .unspecified) }.map(\.height).average()!
            let sizes = subviews.map { $0.dimensions(in: .init(width: nil, height: averageHeight)) }
            
            var width: CGFloat = .zero
            var height: CGFloat = .zero
            var deltaHeight: CGFloat = .zero
            
            var resultWidth: CGFloat = .zero
            
            for size in sizes {
                if width + (spacing.horizontal ?? 0) + size.width <= proposedWidth || width == 0 {
                    width += size.width + (spacing.horizontal ?? 0)
                    deltaHeight = max(deltaHeight, size.height)
                } else {
                    resultWidth = max(width, resultWidth)
                    height += deltaHeight + (spacing.vertical ?? 0)
                    deltaHeight = size.height
                    width = size.width
                }
            }
            
            return CGSize(width: max(width, resultWidth), height: height + (spacing.vertical ?? 0) + deltaHeight)
        } else {
            let sizes = subviews.map { $0.dimensions(in: proposal) }
            return CGSize(width: sizes.reduce(0) { $0 + (spacing.vertical ?? 0) + $1.width }, height: sizes.map(\.height).max()!)
        }
    }
    
    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        guard !subviews.isEmpty else { return }
        
        let averageHeight = subviews.map { $0.dimensions(in: .unspecified) }.map(\.height).average()!
        let sizes = subviews.map { $0.dimensions(in: .init(width: nil, height: averageHeight)) }
        
        var width: CGFloat = .zero
        var height: CGFloat = .zero
        var deltaHeight: CGFloat = .zero
        
        for (index, subview) in subviews.enumerated() {
            let size = sizes[index]
            if width + (spacing.horizontal ?? 0) + size.width <= bounds.width || width == 0 {
                subview.place(at: bounds.origin + CGPoint(x: width, y: height), proposal: .init(width: nil, height: averageHeight))
                
                width += size.width + (spacing.horizontal ?? 0)
                deltaHeight = max(deltaHeight, size.height)
            } else {
                width = size.width + (spacing.horizontal ?? 0)
                deltaHeight = size.height
                height += deltaHeight + (spacing.vertical ?? 0)
                
                subview.place(at: bounds.origin + CGPoint(x: .zero, y: height), proposal: .init(width: nil, height: averageHeight))
            }
        }
    }
    
    
    public init(spacing: Spacing = .init(horizontal: 5, vertical: 5)) {
        self.spacing = spacing
    }
    
    
    /// The padding distance between items
    public struct Spacing: Equatable, ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral {
        
        public let horizontal: CGFloat?
        
        public let vertical: CGFloat?
        
        
        /// Provides an indication of spacings.
        ///
        /// - Parameters:
        ///   - horizontal: The horizontal spacing
        ///   - vertical: The vertical spacing
        public init(horizontal: CGFloat? = nil, vertical: CGFloat? = nil) {
            self.horizontal = horizontal
            self.vertical = vertical
        }
        
        public init(floatLiteral value: FloatLiteralType) {
            self.init(horizontal: value, vertical: value)
        }
        
        public init(integerLiteral value: IntegerLiteralType) {
            self.init(floatLiteral: FloatLiteralType(value))
        }
        
        /// Indicates no padding required.
        public static let none = Spacing(horizontal: nil, vertical: nil)
        
    }
    
}


#Preview {
    FilledVGrid {
        ForEach(0..<10, id: \.self) {
            Text($0.description)
        }
    }
    .padding()
    .frame(maxWidth: .infinity, maxHeight: .infinity)
}
