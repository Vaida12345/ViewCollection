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
    
    @State private var contentSize = CGSize(width: 100, height: 100)
    @State private var containerSize = CGSize(width: 100, height: 100)
    
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
                        .onGeometryChange(for: CGSize.self, of: \.size) {
                            self.contentSize = $1
                        }
                        .presentationBackground {
                            Canvas { context, size in
                                context.fill(
                                    Path(roundedRect: CGRect(origin: CGPoint(x: padding.width, y: padding.height),
                                                             size: contentSize),
                                         cornerRadius: 21),
                                    with: .style(.background)
                                )
                            }
                            .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.2), radius: 40)
                        }
                }
                .ignoresSafeArea()
            } else {
                content
                    .presentationBackground(.background)
            }
        }
    }
}


extension View {
    
    /// Allows floating sheet on landscape iPhones.
    ///
    /// The layout is only activated when an iPhone is in landscape mode, at which point it displays the sheet in a manner similar to that on an iPad.
    ///
    /// ![Preview](floatingSheetLayout)
    @available(iOS 18, *)
    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @available(visionOS, unavailable)
    public func floatingSheetLayout() -> some View {
        self.modifier(FloatingSheetLayoutModifier())
    }
    
}
