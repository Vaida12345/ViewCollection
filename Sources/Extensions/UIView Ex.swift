//
//  UIView Ex.swift
//  ViewCollection
//
//  Created by Vaida on 2026-09-12.
//

#if canImport(UIKit)
import UIKit

extension UIView {
    
    /// Returns the viewController associated with the view, if any.
    public var viewController: UIViewController? {
        sequence(first: next, next: { $0?.next })
            .first { $0 is UIViewController } as? UIViewController
    }
}
#endif
