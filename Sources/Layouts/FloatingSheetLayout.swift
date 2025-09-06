//
//  FloatingSheetLayout.swift
//  ViewCollection
//
//  Created by Vaida on 4/25/25.
//

import SwiftUI


@available(iOS, introduced: 18.0, deprecated: 26.0, message: "Use `presentationDetents` and `presentationCompactAdaptation` instead.")
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
    var padding: CGSize {
        CGSize(
            width: (containerSize.width - contentSize.width) / 2,
            height: (containerSize.height - contentSize.height) / 2
        )
    }
    
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    
    
    func body(content: Content) -> some View {
        Group {
            if verticalSizeClass == .compact {
                ZStack {
                    Color.clear
                        .onGeometryChange(for: CGSize.self, of: \.size) {
                            self.containerSize = $1
                        }
                    
                    content
                        .modifier(FloatingSheetConditionalHorizontalLayoutModifier(horizontal: horizontal, contentSize: $contentSize, safeAreaInsets: safeAreaInsets))
                        .modifier(FloatingSheetConditionalVerticalLayoutModifier(vertical: vertical, contentSize: $contentSize, safeAreaInsets: safeAreaInsets))
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

@available(iOS, introduced: 18.0, deprecated: 26.0)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
private struct FloatingSheetConditionalHorizontalLayoutModifier: ViewModifier {
    
    let horizontal: DimensionConstrain?
    
    @Binding var contentSize: CGSize
    let safeAreaInsets: EdgeInsets
    
    func body(content: Content) -> some View {
        switch horizontal {
        case .fixed(let width):
            content.frame(width: width)
                .onAppear { self.contentSize.width = width }
        case .max(let width):
            content.frame(maxWidth: width)
                .onGeometryChange(for: CGFloat.self, of: \.size.width) { self.contentSize.width = $1 }
        case .min(let width):
            content.frame(minWidth: width)
                .onGeometryChange(for: CGFloat.self, of: \.size.width) { self.contentSize.width = $1 }
        case .padding:
            content.padding(.horizontal, horizontal!.padding(safeAreaInsets.leading, safeAreaInsets.trailing)!)
                .onGeometryChange(for: CGFloat.self, of: \.size.width) { self.contentSize.width = $1 }
        case nil:
            content
        }
    }
}

@available(iOS, introduced: 18.0, deprecated: 26.0)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
private struct FloatingSheetConditionalVerticalLayoutModifier: ViewModifier {
    
    let vertical: DimensionConstrain?
    
    @Binding var contentSize: CGSize
    let safeAreaInsets: EdgeInsets
    
    func body(content: Content) -> some View {
        switch vertical {
        case .fixed(let height):
            content.frame(height: height)
                .onAppear { self.contentSize.height = height }
        case .max(let height):
            content.frame(maxHeight: height)
                .onGeometryChange(for: CGFloat.self, of: \.size.height) { self.contentSize.height = $1 }
        case .min(let height):
            content.frame(maxHeight: height)
                .onGeometryChange(for: CGFloat.self, of: \.size.height) { self.contentSize.height = $1 }
        case .padding:
            content.padding(.vertical, vertical!.padding(safeAreaInsets.top, safeAreaInsets.bottom)!)
                .onGeometryChange(for: CGFloat.self, of: \.size.height) { self.contentSize.height = $1 }
        case nil:
            content
        }
    }
}

#if os(iOS)
#Preview(traits: .landscapeLeft) {
    DebugGridView()
        .sheet(isPresented: .constant(true)) {
            Text("Sheet")
                .floatingSheetLayout(horizontal: .max(500), vertical: .max(300))
        }
}
#endif



/// The layout constrains.
@available(iOS, introduced: 18.0, deprecated: 26.0)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
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
    
    fileprivate func padding(_ safeAreaInset1: CGFloat, _ safeAreaInset2: CGFloat) -> CGFloat? {
        guard case let .padding(padding, ignoresSafeArea) = self else { return nil }
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
    /// - Parameters:
    ///   - horizontal: Specifies the horizontal constrains.
    ///   - vertical: Specifies the vertical constrains.
    ///
    /// > Deprecated:
    /// > Starting from iOS 26, `presentationBackground` no longer supports transparency. Please use `SwiftUI`-native methods instead.
    /// > ```swift
    /// > Text("123456")
    /// >   .presentationDetents([.fraction(0.5), .fraction(0.9)])
    /// >   .presentationCompactAdaptation(.sheet)
    /// >   .presentationSizing(.form)
    /// > ```
    @available(iOS, introduced: 18.0, deprecated: 26.0, message: "Use `presentationDetents` and `presentationCompactAdaptation` instead.")
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
