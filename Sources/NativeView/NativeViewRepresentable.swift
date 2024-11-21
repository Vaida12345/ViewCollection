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
    
    
    associatedtype ViewType: NativeView
    
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
    
    
    associatedtype ViewType: NativeView
    
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
    
}

#endif


extension NativeViewRepresentable {
    
    public func sizeThatFits(_ proposal: ProposedViewSize, view: Self.ViewType, context: Self.Context) -> CGSize? {
        nil
    }
    
}
