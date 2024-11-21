//
//  NativeViewController.swift
//  ViewCollection
//
//  Created by Vaida on 11/21/24.
//

#if canImport (AppKit) && !targetEnvironment (macCatalyst)

import AppKit

public typealias NativeViewController = NSViewController

#elseif canImport(UIKit)

import UIKit

public typealias NativeViewController = UIViewController

#endif
