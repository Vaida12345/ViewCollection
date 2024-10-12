//
//  OnSwipeAction.swift
//  The Stratum Module
//
//  Created by Vaida on 2023/12/16.
//  Copyright © 2019 - 2024 Vaida. All rights reserved.
//


import SwiftUI


@available(macOS 14, iOS 17, watchOS 10, tvOS 17, *)
private struct OnSwipeAction: ViewModifier {
    
    private let edge: Edge
    
    private let handler: () -> Void
    
    private let sensitivity: Double
    
    private let maxDistance: Double
    
    private let disabled: Bool
    
    @State private var offset = CGSize.zero
    
    @Binding private var progress: Double
    
    
    private var gesture: some Gesture {
        DragGesture()
            .onChanged { value in
                withAnimation(.interpolatingSpring) {
                    switch edge {
                    case .top:
                        if value.translation.height > 0 {
                            offset.height = decay(value.translation.height, sensitivity: sensitivity, scale: maxDistance)
                        } else {
                            offset.height = value.translation.height
                            progress = min(abs(value.translation.height) / maxDistance, 1)
                        }
                        
//                        offset.width = decay(value.translation.width, sensitivity: sensitivity, scale: maxDistance)
                    case .leading:
                        if value.translation.width > 0 {
                            offset.width = decay(value.translation.width, sensitivity: sensitivity, scale: maxDistance)
                        } else {
                            offset.width = value.translation.width
                            progress = min(abs(value.translation.width) / maxDistance, 1)
                        }
                        
//                        offset.height = decay(value.translation.height, sensitivity: sensitivity, scale: maxDistance)
                    case .bottom:
                        if value.translation.height > 0 {
                            offset.height = value.translation.height
                            progress = min(abs(value.translation.height) / maxDistance, 1)
                        } else {
                            offset.height = decay(value.translation.height, sensitivity: sensitivity, scale: maxDistance)
                        }
                        
//                        offset.width = decay(value.translation.width, sensitivity: sensitivity, scale: maxDistance)
                    case .trailing:
                        if value.translation.width > 0 {
                            offset.width = value.translation.width
                            progress = min(abs(value.translation.width) / maxDistance, 1)
                        } else {
                            offset.width = decay(value.translation.width, sensitivity: sensitivity, scale: maxDistance)
                        }
                        
//                        offset.height = decay(value.translation.height, sensitivity: sensitivity, scale: maxDistance)
                    }
                }
            }
            .onEnded { value in
                switch edge {
                case .top:
                    handleOnEnd(satisfied: value.translation.height < -maxDistance)
                case .leading:
                    handleOnEnd(satisfied: value.translation.width < -maxDistance)
                case .bottom:
                    handleOnEnd(satisfied: value.translation.height > maxDistance)
                case .trailing:
                    handleOnEnd(satisfied: value.translation.width > maxDistance)
                }
            }
    }
    
    private func handleOnEnd(satisfied: Bool) {
        if satisfied {
            withAnimation(.interpolatingSpring) {
                handler()
                progress = 1
            } completion: {
                offset = .zero
            }
        } else {
            withAnimation(.interpolatingSpring) {
                offset = .zero
                progress = 0
            }
        }
    }
    
    fileprivate func body(content: Content) -> some View {
        content
            .gesture(gesture, including: disabled ? .subviews: .all)
            .offset(disabled ? .zero : offset)
    }
    
    /// - Parameters:
    ///   - sensitivity: The larger the value, the faster it would to reach its asymptote.
    ///   - scale: The scaling factor, ie, the asymptote.
    private func decay(_ x: Double, sensitivity: Double, scale: Double) -> Double {
        scale * tanh(sensitivity * x)
    }
    
    /// Creates the action.
    ///
    /// - Parameters:
    ///   - edge: The direction in which the view can be dragged.
    ///   - sensitivity: The larger the value, the faster it would to reach its asymptote of the opposite direction.
    ///   - maxDistance: The max distance the view can move in the opposite direction. This is also the threshold above which the `handler` is called.
    ///   - progress: The value between 0 and 1 indicating the swap progress.
    ///   - disabled: Whether the swap action is disabled. Useful when gesture hierarchy is chaotic.
    ///   - handler: The handler called when the moved distance is greater than `maxDistance`.
    fileprivate init(to edge: Edge, sensitivity: Double, maxDistance: Double, progress: Binding<Double>? = nil, disabled: Bool = false, handler: @escaping () -> Void) {
        precondition(maxDistance > 0)
        precondition(sensitivity > 0)
        self.edge = edge
        self.sensitivity = sensitivity
        self.maxDistance = maxDistance
        self._progress = progress ?? .constant(0)
        self.disabled = disabled
        self.handler = handler
    }
    
}


@available(macOS 14, iOS 17, watchOS 10, tvOS 17, *)
extension View {
    
    /// Calls the `handler` on swap to `edge`.
    ///
    /// - Note: A `withAnimation` block is applied to `handler`, as it is required for animation.
    ///
    /// - Parameters:
    ///   - edge: The direction in which the view can be dragged.
    ///   - sensitivity: The larger the value, the faster it would to reach its asymptote of the opposite direction.
    ///   - maxDistance: The max distance the view can move in the opposite direction. This is also the threshold above which the `handler` is called.
    ///   - disabled: Whether the swap action is disabled. Useful when gesture hierarchy is chaotic.
    ///   - progress: The value between 0 and 1 indicating the swap progress.
    ///   - handler: The handler called when the moved distance is greater than `maxDistance`.
    public func onSwipe(to edge: Edge, sensitivity: Double = 2, maxDistance: Double = 50, progress: Binding<Double>? = nil, disabled: Bool = false, handler: @escaping () -> Void) -> some View {
        self.modifier(OnSwipeAction(to: edge, sensitivity: sensitivity, maxDistance: maxDistance, progress: progress, disabled: disabled, handler: handler))
    }
    
}
