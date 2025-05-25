//
//  FloatingSheetLayout.swift
//  ViewCollection
//
//  Created by Vaida on 4/25/25.
//

import SwiftUI


@available(iOS 18, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
private struct FloatingSheetLayoutModifier: ViewModifier {
    
    let horizontal: DimensionConstrain?
    let vertical: DimensionConstrain?
    
    @State private var contentSize = CGSize(width: 100, height: 100)
    @State private var containerSize = CGSize(width: 100, height: 100)
    @State private var safeAreaInsets = EdgeInsets()
    
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    
    
    func body(content: Content) -> some View {
        Group {
            if verticalSizeClass == .compact {
                let padding = CGSize(
                    width: (containerSize.width - contentSize.width) / 2,
                    height: (containerSize.height - contentSize.height) / 2
                )
                
                ZStack {
                    Color.clear
                        .onGeometryChange(for: CGSize.self, of: \.size) {
                            self.containerSize = $1
                        }
                    
                    content
                        .frame(
                            width: horizontal?.fixed,
                            height: vertical?.fixed
                        )
                        .frame(
                            minWidth: horizontal?.min,
                            maxWidth: horizontal?.max,
                            minHeight: vertical?.min,
                            maxHeight: vertical?.max
                        )
                        .onGeometryChange(for: CGSize.self, of: \.size) {
                            self.contentSize = $1
                        }
                        .padding(.horizontal, horizontal?.padding(safeAreaInsets.leading, safeAreaInsets.trailing) ?? 0)
                        .padding(.vertical, vertical?.padding(safeAreaInsets.top, safeAreaInsets.bottom) ?? 0)
                        .presentationBackground {
                            Canvas { context, size in
                                context.fill(
                                    Path(roundedRect: CGRect(origin: CGPoint(x: padding.width, y: padding.height),
                                                             size: contentSize),
                                         cornerRadius: 21),
                                    with: .style(.background)
                                )
                            }
                            .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.25), radius: 40)
                        }
                }
                .ignoresSafeArea()
                .onGeometryChange(for: EdgeInsets.self, of: \.safeAreaInsets) {
                    self.safeAreaInsets = $1
                }
            } else {
                content
                    .presentationBackground(.background)
            }
        }
    }
}

#if os(iOS)
#Preview(traits: .landscapeLeft) {
    Text("Content")
        .sheet(isPresented: .constant(true)) {
            Text("Sheet")
                .floatingSheetLayout(horizontal: .max(500), vertical: .max(300))
        }
}
#endif



/// The layout constrains.
public enum DimensionConstrain {
    /// Specifies a fixed length.
    case fixed(CGFloat)
    /// Specifies a maximum length.
    case max(CGFloat)
    /// Specifies a minimum length.
    case min(CGFloat)
    /// Specifies the padding on both sides.
    case padding(CGFloat, ignoresSafeArea: Bool)
    
    /// Specifies the padding on both sides.
    ///
    /// - Note: Layouts are also constrained by safe areas.
    public static func padding(_ padding: CGFloat) -> DimensionConstrain {
        .padding(padding, ignoresSafeArea: false)
    }
    
    
    fileprivate var fixed: CGFloat? {
        switch self {
        case .fixed(let value): value
        default: nil
        }
    }
    
    fileprivate var max: CGFloat? {
        switch self {
        case .max(let value): value
        default: nil
        }
    }
    
    fileprivate var min: CGFloat? {
        switch self {
        case .min(let value): value
        default: nil
        }
    }
    
    fileprivate var padding: (CGFloat, ignoresSafeArea: Bool)? {
        switch self {
        case .padding(let value, let ignoresSafeArea): (value, ignoresSafeArea)
        default: nil
        }
    }
    
    fileprivate func padding(_ safeAreaInset1: CGFloat, _ safeAreaInset2: CGFloat) -> CGFloat? {
        guard let (padding, ignoresSafeArea) = self.padding else { return nil }
        let inset: CGFloat = ignoresSafeArea ? 0 : Swift.max(safeAreaInset1, safeAreaInset2)
        return padding + inset
    }
}


extension View {
    
    /// Allows floating sheet on landscape iPhones.
    ///
    /// The layout is only activated when an iPhone is in landscape mode, at which point it displays the sheet in a manner similar to that on an iPad.
    ///
    /// > Tip:
    /// > To have iPadOS sheet fit to the content, use the SwiftUI modifier,
    /// > ```swift
    /// > .presentationSizing(.fitted.sticky(horizontal: true))
    /// > ```
    ///
    /// ![Preview](floatingSheetLayout)
    ///
    /// - Warning: `presentationDetents` must support `large` when landscape, otherwise crash.
    ///
    /// - Bug: Currently does not support `ViewThatFits`, can crash.
    ///
    /// - Parameters:
    ///   - horizontal: Specifies the horizontal constrains.
    ///   - vertical: Specifies the vertical constrains.
    @available(iOS 18, *)
    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @available(visionOS, unavailable)
    public func floatingSheetLayout(
        horizontal: DimensionConstrain? = .padding(16),
        vertical: DimensionConstrain? = .padding(16)
    ) -> some View {
        self.modifier(FloatingSheetLayoutModifier(horizontal: horizontal, vertical: vertical))
    }
    
}
