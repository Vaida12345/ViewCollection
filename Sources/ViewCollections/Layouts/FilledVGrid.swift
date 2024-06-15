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
/// - Note: The minimum size strategy is to place its contents 4 items a row.
///
/// ```swift
/// ScrollView(.vertical) {
///     ContainerView(alignment: .topLeading) {
///         FilledVGrid {
///             ForEach(0..<100) { i in
///                 Rectangle()
///                     .fill(Color.allColors.randomElement()!)
///                     .overlay {
///                         Text(i.description)
///                     }
///                     .frame(width: 100, height: 100)
///             }
///         }
///     }
/// }
/// ```
///
/// - Tip: You could embed a grid inside ``Container``, and provide a `topLeading` alignment.
///
/// ![Color Palette](orangePalette)
public struct FilledVGrid: Layout {
    
    private let spacing: Spacing
    
    enum Strategy {
        case oneRow, oneColumn, infHeight(maxWidth: CGFloat), infHeight(maxColumnCount: Int), minWidthUnderLimitedHeight(maxColumnCount: Int, maxHeight: CGFloat), minHeightUnderLimitedWidth(maxWidth: CGFloat), minimumSize, bothConstrainsPrioritizeWidth(maxWidth: CGFloat)
    }
    
    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        // proposal size of nil would mean no constrain, for example, the height is nil for vertical scroll view.
        // side of zero would indicate the min length of the side. Should prioritize on filling the other side.
        
        guard !subviews.isEmpty else { return .zero }
        
        let dimensions = subviews.map { $0.dimensions(in: proposal) }
        let averageHeight = dimensions.map(\.height).mean!
        let averageWidth = dimensions.map(\.width).mean!
        let sizes = subviews.map { $0.dimensions(in: .init(width: nil, height: averageHeight)) }
        
        func calculateMinimumSize() -> (size: CGSize, strategy: Strategy)  {
            // the minimum size, 4 items a row
            var width: CGFloat = -(spacing.horizontal ?? 0)
            var height: CGFloat = .zero
            var deltaHeight: CGFloat = .zero
            
            var resultWidth: CGFloat = .zero
            var count = 0
            
            for size in sizes {
                if count < 4 {
                    width += (spacing.horizontal ?? 0) + size.width
                    deltaHeight = max(deltaHeight, size.height)
                    count += 1
                } else {
                    count = 0
                    resultWidth = max(width, resultWidth)
                    height += deltaHeight + (spacing.vertical ?? 0)
                    deltaHeight = size.height
                    width = size.width
                }
            }
            
            return (CGSize(width: max(width, resultWidth), height: height + deltaHeight), .minimumSize)
        }
        
        func buildOneColumn() -> (size: CGSize, strategy: Strategy) {
            (CGSize(width: averageWidth, height: dimensions.map(\.height).reduce({ $0 + (spacing.vertical ?? 0) + $1 })!), .oneColumn)
        }
        
        func buildOneRow() -> (size: CGSize, strategy: Strategy) {
            (CGSize(width: dimensions.map(\.width).reduce({ $0 + (spacing.horizontal ?? 0) + $1 })!, height: averageHeight), .oneRow)
        }
        
        func buildMinHeight(maxWidth: CGFloat?) -> (size: CGSize, strategy: Strategy) {
            if maxWidth == nil || maxWidth!.isInfinite {
                return buildOneRow()
            } else if maxWidth == 0 {
                // need to minimize both
                return calculateMinimumSize()
            } else {
                // prioritize width to ensure min height
                var width: CGFloat = -(spacing.horizontal ?? 0)
                var height: CGFloat = .zero
                var deltaHeight: CGFloat = .zero
                
                var resultWidth: CGFloat = .zero
                var count = 0
                
                for size in sizes {
                    if (maxWidth != nil) ? (width + (spacing.horizontal ?? 0) + size.width <= maxWidth!) : (count < 4) {
                        width += (spacing.horizontal ?? 0) + size.width
                        deltaHeight = max(deltaHeight, size.height)
                        count += 1
                    } else {
                        resultWidth = max(width, resultWidth)
                        height += deltaHeight + (spacing.vertical ?? 0)
                        deltaHeight = size.height
                        width = size.width
                        count = 0
                    }
                }
                
                return (CGSize(width: max(width, resultWidth), height: height + deltaHeight), .minHeightUnderLimitedWidth(maxWidth: maxWidth!))
            }
        }
        
        func buildInfHeight(maxWidth: CGFloat?) -> (size: CGSize, strategy: Strategy) {
            if maxWidth == 0 {
                return buildOneColumn()
            }
            
            var width: CGFloat = -(spacing.horizontal ?? 0)
            var height: CGFloat = .zero
            var deltaHeight: CGFloat = .zero
            
            var resultWidth: CGFloat = .zero
            var count = 0
            
            for size in sizes {
                if (maxWidth != nil) ? (width + (spacing.horizontal ?? 0) + size.width <= maxWidth!) : (count < 4) {
                    width += (spacing.horizontal ?? 0) + size.width
                    deltaHeight = max(deltaHeight, size.height)
                    count += 1
                } else {
                    resultWidth = max(width, resultWidth)
                    height += deltaHeight + (spacing.vertical ?? 0)
                    deltaHeight = size.height
                    width = size.width
                    count = 0
                }
            }
            
            return (CGSize(width: max(width, resultWidth), height: height + deltaHeight), maxWidth == nil ? .infHeight(maxColumnCount: 4) : .infHeight(maxWidth: maxWidth!))
        }
        
        func buildFiniteHeight(maxWidth: CGFloat?, height: CGFloat) -> (size: CGSize, strategy: Strategy) {
            if maxWidth == nil || maxWidth!.isInfinite {
                return buildOneRow()
            } else if maxWidth == 0 {
                // prioritize height to ensure min width
                let stackSize = Int(height / averageHeight)
                let columnCount = (subviews.count / stackSize) + (subviews.count % stackSize == 0 ? 0 : 1)
                
                var width: CGFloat = -(spacing.horizontal ?? 0)
                var height: CGFloat = .zero
                var deltaHeight: CGFloat = .zero
                
                var resultWidth: CGFloat = .zero
                var count = 0
                
                for size in sizes {
                    if (count < columnCount) {
                        width += (spacing.horizontal ?? 0) + size.width
                        deltaHeight = max(deltaHeight, size.height)
                        count += 1
                    } else {
                        resultWidth = max(width, resultWidth)
                        height += deltaHeight + (spacing.vertical ?? 0)
                        deltaHeight = size.height
                        width = size.width
                        count = 0
                    }
                }
                
                return (CGSize(width: max(width, resultWidth), height: height + deltaHeight), .minWidthUnderLimitedHeight(maxColumnCount: columnCount, maxHeight: height))
            } else {
                // both has constrains, has to choose one, prioritize width
                let size = buildInfHeight(maxWidth: maxWidth).size
                return (size, .bothConstrainsPrioritizeWidth(maxWidth: maxWidth!))
            }
        }
        
        
        func calculateSize() -> (size: CGSize, strategy: Strategy) {
            
            if proposal.height == nil || proposal.height!.isInfinite {
                // no height constrain
                return buildInfHeight(maxWidth: proposal.width)
            } else if proposal.height == 0 {
                return buildMinHeight(maxWidth: proposal.width)
            } else {
                return buildFiniteHeight(maxWidth: proposal.width, height: proposal.height!)
            }
        }
        
        let size = calculateSize()
        
//        print("proposal", proposal, size)
        return size.size
    }
    
    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
//        print("bounce", bounds.origin, bounds.size, "proposal", proposal)
        guard !subviews.isEmpty else { return }
        
        let averageHeight = subviews.map { $0.dimensions(in: .unspecified) }.map(\.height).mean!
        let sizes = subviews.map { $0.dimensions(in: .init(width: nil, height: averageHeight)) }
        
        var width: CGFloat = 0
        var height: CGFloat = .zero
        var deltaHeight: CGFloat = .zero
        
        for (index, subview) in subviews.enumerated() {
            let size = sizes[index]
            if width + size.width <= bounds.width || width == 0 {
                subview.place(at: bounds.origin + CGPoint(x: width, y: height), proposal: .init(width: nil, height: averageHeight))
//                print("place_at", bounds.origin + CGPoint(x: width, y: height))
                
                width += size.width + (spacing.horizontal ?? 0)
                deltaHeight = max(deltaHeight, size.height)
            } else {
                width = size.width + (spacing.horizontal ?? 0)
                deltaHeight = size.height
                height += deltaHeight + (spacing.vertical ?? 0)
                
                subview.place(at: bounds.origin + CGPoint(x: .zero, y: height), proposal: .init(width: nil, height: averageHeight))
//                print("place^at", bounds.origin + CGPoint(x: .zero, y: height))
            }
        }
    }
    
    
    
    /// Creates the layout
    ///
    /// - Parameters:
    ///   - spacing: The spacing between each child
    public init(spacing: Spacing = 5) {
        self.spacing = spacing
    }
    
    
    /// The padding distance between items
    public struct Spacing: Equatable, ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral, Sendable {
        
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
}
