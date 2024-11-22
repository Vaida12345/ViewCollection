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
///
/// ```swift
/// struct PianoView: NativeViewControllerRepresentable {
///
///     func makeViewController(context: Context) -> some NativeViewController {
///
///     }
///
///     func updateViewController(_ viewController: ViewControllerType, context: Context) {
///
///     }
/// }
/// ```
public protocol NativeViewControllerRepresentable: NSViewControllerRepresentable {
    
    @MainActor @preconcurrency
    func makeViewController(context: Self.Context) -> Self.ViewControllerType
    
    @MainActor @preconcurrency
    func updateViewController(_ view: Self.ViewControllerType, context: Self.Context)
    
    @MainActor @preconcurrency
    func sizeThatFits(_ proposal: ProposedViewSize, viewController: Self.ViewControllerType, context: Self.Context) -> CGSize?
    
    
    associatedtype ViewControllerType: NativeViewController
    
}

extension NativeViewControllerRepresentable {
    
    public func makeNSViewController(context: Self.Context) -> ViewControllerType {
        self.makeViewController(context: context)
    }
    
    public func updateNSViewController(_ nsViewController: ViewControllerType, context: Self.Context) {
        self.updateViewController(nsViewController, context: context)
    }
    
    public func sizeThatFits(_ proposal: ProposedViewSize, nsViewController: ViewControllerType, context: Self.Context) -> CGSize? {
        self.sizeThatFits(proposal, viewController: nsViewController, context: context)
    }
    
}


#elseif canImport(UIKit)

import UIKit

/// A wrapper to `UIViewRepresentable`
public protocol NativeViewControllerRepresentable: UIViewControllerRepresentable {
    
    @MainActor @preconcurrency
    func makeViewController(context: Self.Context) -> Self.ViewControllerType
    
    @MainActor @preconcurrency
    func updateViewController(_ view: Self.ViewControllerType, context: Self.Context)
    
    @MainActor @preconcurrency
    func sizeThatFits(_ proposal: ProposedViewSize, viewController: Self.ViewControllerType, context: Self.Context) -> CGSize?
    
    
    associatedtype ViewControllerType: NativeViewController
    
}

extension NativeViewControllerRepresentable {
    
    public func makeUIViewController(context: Self.Context) -> ViewControllerType {
        self.makeViewController(context: context)
    }
    
    public func updateUIViewController(_ uiViewController: ViewControllerType, context: Self.Context) {
        self.updateViewController(uiViewController, context: context)
    }
    
    public func sizeThatFits(_ proposal: ProposedViewSize, uiViewController: ViewControllerType, context: Self.Context) -> CGSize? {
        self.sizeThatFits(proposal, viewController: uiViewController, context: context)
    }
    
}

#endif


extension NativeViewControllerRepresentable {
    
    public func sizeThatFits(_ proposal: ProposedViewSize, viewController: Self.ViewControllerType, context: Self.Context) -> CGSize? {
        nil
    }
    
}
