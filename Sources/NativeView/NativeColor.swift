//
//  NativeColor.swift
//  ViewCollection
//
//  Created by Vaida on 11/21/24.
//

#if canImport (AppKit) && !targetEnvironment (macCatalyst)

import AppKit

public typealias NativeColor = NSColor

#elseif canImport(UIKit)

import UIKit

public typealias NativeColor = UIColor

#endif
