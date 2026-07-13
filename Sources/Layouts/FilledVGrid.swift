//
//  FilledVGrid.swift
//  The Stratum Module
//
//  Created by Vaida on 6/16/23.
//  Copyright © 2019 - 2024 Vaida. All rights reserved.
//

import SwiftUI
import NativeImage


/// The grid that puts every cell, ideally of *equal height*, in order.
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
/// - Tip: You could embed a grid inside ``ContainerView``, and provide a `topLeading` alignment.
///
/// ![Color Palette](orangePalette)
public struct FilledVGrid: Layout {
    
    private let spacing: Spacing
    
    private var horizontalSpacing: CGFloat {
        spacing.horizontal ?? 0
    }
    
    private var verticalSpacing: CGFloat {
        spacing.vertical ?? 0
    }
    
    private struct Row {
        let range: Range<Int>
        let width: CGFloat
        let height: CGFloat
    }
    
    public struct Cache {
        
        var dimensions: [ViewDimensions] = []
        
        var averageHeight: CGFloat = 0
        
        var maxWidth: CGFloat = 0
        
    }
    
    /// Refreshes cached measurements when SwiftUI invalidates the layout cache.
    ///
    /// The concrete proposal is not available in this callback, so measurements are
    /// produced in `sizeThatFits` and refreshed defensively in `placeSubviews` when needed.
    public func updateCache(_ cache: inout Cache, subviews: Subviews) {
        guard cache.dimensions.count == subviews.count else {
            cache.dimensions.removeAll(keepingCapacity: true)
            cache.averageHeight = 0
            cache.maxWidth = 0
            return
        }
    }
    
    /// Returns the grid size for the proposed constraints.
    ///
    /// Width-constrained proposals wrap rows at the available width. Unconstrained
    /// or minimum-size proposals use four items per row, matching the documented
    /// minimum sizing strategy, except for finite-height minimum-width proposals
    /// where the column count is derived from the available height.
    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Cache) -> CGSize {
        guard !subviews.isEmpty else { return .zero }
        
        updateMeasurements(in: &cache, subviews: subviews, proposal: proposal)
        
        if proposal.height == nil || proposal.height?.isInfinite == true {
            return sizeForRows(rows(for: cache.dimensions, maxWidth: proposal.width, fallbackColumnCount: 4))
        }
        
        if proposal.height == 0 {
            guard let proposedWidth = proposal.width, proposedWidth.isFinite else {
                return oneRowSize(for: cache.dimensions, averageHeight: cache.averageHeight)
            }
            
            guard proposedWidth > 0 else {
                return sizeForRows(rows(for: cache.dimensions, maxWidth: nil, fallbackColumnCount: 4))
            }
            
            return sizeForRows(rows(for: cache.dimensions, maxWidth: proposedWidth, fallbackColumnCount: 4))
        }
        
        guard let proposedWidth = proposal.width, proposedWidth.isFinite else {
            return oneRowSize(for: cache.dimensions, averageHeight: cache.averageHeight)
        }
        
        guard proposedWidth > 0 else {
            let rowCount = fittingRowCount(for: proposal.height ?? 0, averageHeight: cache.averageHeight)
            let columnCount = max(1, Int(ceil(CGFloat(subviews.count) / CGFloat(rowCount))))
            return sizeForRows(rows(for: cache.dimensions, maxWidth: nil, fallbackColumnCount: columnCount))
        }
        
        return sizeForRows(rows(for: cache.dimensions, maxWidth: proposedWidth, fallbackColumnCount: 4))
    }
    
    /// Places subviews using the same row wrapping rules as `sizeThatFits`.
    ///
    /// The cache is refreshed if SwiftUI calls placement before measurement or after
    /// the subview count changes, preventing stale cache indexing.
    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Cache) {
        guard !subviews.isEmpty else { return }
        
        if cache.dimensions.count != subviews.count {
            updateMeasurements(in: &cache, subviews: subviews, proposal: proposal)
        }
        
        let maxWidth = bounds.width.isFinite ? max(0, bounds.width) : nil
        let rows = rows(for: cache.dimensions, maxWidth: maxWidth, fallbackColumnCount: 4)
        var y = bounds.minY
        
        for row in rows {
            var x = bounds.minX
            
            for index in row.range {
                let size = cache.dimensions[index]
                subviews[index].place(at: CGPoint(x: x, y: y),
                                      proposal: ProposedViewSize(width: size.width, height: row.height))
                x += size.width + horizontalSpacing
            }
            
            y += row.height + verticalSpacing
        }
    }
    
    /// Creates the layout.
    ///
    /// - Parameters:
    ///   - spacing: The spacing between each child.
    public init(spacing: Spacing = 5) {
        self.spacing = spacing
    }
    
    /// Creates the initial layout cache used for measured subview dimensions.
    public func makeCache(subviews: Subviews) -> Cache {
        Cache()
    }
    
    /// The padding distance between items.
    public struct Spacing: Equatable, ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral, Sendable {
        
        public let horizontal: CGFloat?
        
        public let vertical: CGFloat?
        
        
        /// Provides an indication of spacings.
        ///
        /// - Parameters:
        ///   - horizontal: The horizontal spacing.
        ///   - vertical: The vertical spacing.
        public init(horizontal: CGFloat? = nil, vertical: CGFloat? = nil) {
            self.horizontal = horizontal
            self.vertical = vertical
        }
        
        /// Creates equal horizontal and vertical spacing from a floating-point literal.
        public init(floatLiteral value: FloatLiteralType) {
            self.init(horizontal: value, vertical: value)
        }
        
        /// Creates equal horizontal and vertical spacing from an integer literal.
        public init(integerLiteral value: IntegerLiteralType) {
            self.init(floatLiteral: FloatLiteralType(value))
        }
        
        /// Indicates no padding required.
        public static let none = Spacing(horizontal: nil, vertical: nil)
        
    }
    
    /// Measures all subviews and stores aggregate values used by sizing and placement.
    private func updateMeasurements(in cache: inout Cache, subviews: Subviews, proposal: ProposedViewSize) {
        let subviewProposal: ProposedViewSize = if proposal == .zero {
            .zero
        } else if proposal == .infinity {
            .infinity
        } else {
            .unspecified
        }
        
        cache.dimensions = subviews.map { $0.dimensions(in: subviewProposal) }
        cache.averageHeight = averageHeight(for: cache.dimensions)
        cache.maxWidth = cache.dimensions.map(\.width).max() ?? 0
    }
    
    /// Builds rows for the measured dimensions using either a finite width or a fallback column count.
    private func rows(for dimensions: [ViewDimensions], maxWidth: CGFloat?, fallbackColumnCount: Int) -> [Row] {
        guard !dimensions.isEmpty else { return [] }
        
        let columnCount = max(1, fallbackColumnCount)
        var rows: [Row] = []
        var rowStart = dimensions.startIndex
        var rowWidth: CGFloat = 0
        var rowHeight: CGFloat = 0
        var itemCount = 0
        
        for index in dimensions.indices {
            let size = dimensions[index]
            let itemWidth = max(0, size.width)
            let itemHeight = max(0, size.height)
            let nextWidth = itemCount == 0 ? itemWidth : rowWidth + horizontalSpacing + itemWidth
            let shouldWrap: Bool
            
            if let maxWidth, maxWidth.isFinite {
                shouldWrap = itemCount > 0 && nextWidth > max(0, maxWidth)
            } else {
                shouldWrap = itemCount >= columnCount
            }
            
            if shouldWrap {
                rows.append(Row(range: rowStart..<index, width: rowWidth, height: rowHeight))
                rowStart = index
                rowWidth = itemWidth
                rowHeight = itemHeight
                itemCount = 1
            } else {
                rowWidth = nextWidth
                rowHeight = max(rowHeight, itemHeight)
                itemCount += 1
            }
        }
        
        rows.append(Row(range: rowStart..<dimensions.endIndex, width: rowWidth, height: rowHeight))
        return rows
    }
    
    /// Returns the size occupied by the supplied rows, including vertical spacing between rows.
    private func sizeForRows(_ rows: [Row]) -> CGSize {
        guard !rows.isEmpty else { return .zero }
        
        let width = rows.reduce(0) { max($0, $1.width) }
        let height = rows.reduce(0) { $0 + $1.height } + verticalSpacing * CGFloat(rows.count - 1)
        return CGSize(width: max(0, width), height: max(0, height))
    }
    
    /// Returns the unconstrained single-row size for the measured dimensions.
    private func oneRowSize(for dimensions: [ViewDimensions], averageHeight: CGFloat) -> CGSize {
        guard !dimensions.isEmpty else { return .zero }
        
        let width = dimensions.reduce(0) { $0 + max(0, $1.width) } + horizontalSpacing * CGFloat(dimensions.count - 1)
        return CGSize(width: max(0, width), height: max(0, averageHeight))
    }
    
    /// Calculates a nonzero row count that can fit within a finite proposed height.
    private func fittingRowCount(for height: CGFloat, averageHeight: CGFloat) -> Int {
        guard height.isFinite, height > 0, averageHeight > 0 else { return 1 }
        
        let rowHeightWithSpacing = averageHeight + verticalSpacing
        guard rowHeightWithSpacing > 0 else { return 1 }
        
        return max(1, Int(floor((height + verticalSpacing) / rowHeightWithSpacing)))
    }
    
    /// Returns the average measured height for the supplied dimensions.
    private func averageHeight(for dimensions: [ViewDimensions]) -> CGFloat {
        guard !dimensions.isEmpty else { return 0 }
        
        let totalHeight = dimensions.reduce(0) { $0 + max(0, $1.height) }
        return totalHeight / CGFloat(dimensions.count)
    }
    
}


#Preview {
    FilledVGrid {
        ForEach(0..<10, id: \.self) {
            Text($0.description)
        }
    }
}
