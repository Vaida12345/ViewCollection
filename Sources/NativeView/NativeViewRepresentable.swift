//
//  NativeViewRepresentable.swift
//  ViewCollection
//
//  Created by Vaida on 11/21/24.
//

import SwiftUI


#if canImport (AppKit) && !targetEnvironment (macCatalyst)

import AppKit

/// A wrapper to `NSViewRepresentable`
public protocol NativeViewRepresentable: NSViewRepresentable {
    
    @MainActor @preconcurrency
    func makeView(context: Self.Context) -> Self.ViewType
    
    @MainActor @preconcurrency
    func updateView(_ view: Self.ViewType, context: Self.Context)
    
    @MainActor @preconcurrency
    func sizeThatFits(_ proposal: ProposedViewSize, view: Self.ViewType, context: Self.Context) -> CGSize?
    
    @MainActor @preconcurrency
    static func dismantleView(_ view: Self.ViewType, coordinator: Self.Coordinator)
    
    
    associatedtype ViewType: NativeView
    associatedtype Coordinator = Void
    
}

extension NativeViewRepresentable {
    
    public func makeNSView(context: Self.Context) -> ViewType {
        self.makeView(context: context)
    }
    
    public func updateNSView(_ nsView: ViewType, context: Self.Context) {
        self.updateView(nsView, context: context)
    }
    
    public func sizeThatFits(_ proposal: ProposedViewSize, nsView: ViewType, context: Self.Context) -> CGSize? {
        self.sizeThatFits(proposal, view: nsView, context: context)
    }
    
    public static func dismantleNSView(_ nsView: Self.ViewType, coordinator: Coordinator) {
        self.dismantleView(nsView, coordinator: coordinator)
    }
    
}


#elseif canImport(UIKit)

import UIKit

/// A wrapper to `UIViewRepresentable`
public protocol NativeViewRepresentable: UIViewRepresentable {
    
    @MainActor @preconcurrency
    func makeView(context: Self.Context) -> Self.ViewType
    
    @MainActor @preconcurrency
    func updateView(_ view: Self.ViewType, context: Self.Context)
    
    @MainActor @preconcurrency
    func sizeThatFits(_ proposal: ProposedViewSize, view: Self.ViewType, context: Self.Context) -> CGSize?
    
    @MainActor @preconcurrency
    static func dismantleView(_ viewController: Self.ViewType, coordinator: Self.Coordinator)
    
    
    associatedtype ViewType: NativeView
    associatedtype Coordinator = Void
    
}

extension NativeViewRepresentable {
    
    public func makeUIView(context: Self.Context) -> ViewType {
        self.makeView(context: context)
    }
    
    public func updateUIView(_ nsView: ViewType, context: Self.Context) {
        self.updateView(nsView, context: context)
    }
    
    public func sizeThatFits(_ proposal: ProposedViewSize, uiView: ViewType, context: Self.Context) -> CGSize? {
        self.sizeThatFits(proposal, view: uiView, context: context)
    }
    
    public static func dismantleUIView(_ uiView: Self.ViewType, coordinator: Coordinator) {
        Self.dismantleView(uiView, coordinator: coordinator)
    }
    
}

#endif


extension NativeViewRepresentable {
    
    public func sizeThatFits(_ proposal: ProposedViewSize, view: Self.ViewType, context: Self.Context) -> CGSize? {
        nil
    }
    
    public static func dismantleView(_ view: Self.ViewType, coordinator: Self.Coordinator) {
        
    }
    
}
