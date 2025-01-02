//
//  DesignPattern.swift
//  The Stratum Module
//
//  Created by Vaida on 7/15/23.
//  Copyright © 2019 - 2024 Vaida. All rights reserved.
//

import Foundation
import SwiftUI


/// The design pattern should be applied.
///
/// On iPadOS, also pay attention to `horizontalSizeClass`. One should use iOS layouts when `compact`.
public enum DesignPattern: Codable, Equatable {
    case mac, tv, carPlay, vision, watch
    @available(*, deprecated, renamed: "iPhone")
    case phone
    @available(*, deprecated, renamed: "iPad")
    case pad
    case iPad, iPhone
    
    /// The unspecified can be matched against any pattern
    case unspecified
    
    /// The device name
    @inlinable
    public var deviceName: String {
        switch self {
        case .mac:
            "Mac"
        case .phone, .iPhone:
            "iPhone"
        case .pad, .iPad:
            "iPad"
        case .tv:
            "Apple TV"
        case .carPlay:
            "Apple Car Play"
        case .vision:
            "Apple Vision"
        case .watch:
            "Apple Watch"
        case .unspecified:
            "device"
        }
    }
    
    /// The system image for the given device
    @inlinable
    public var systemImage: String {
        switch self {
        case .mac:
            "macbook"
        case .phone, .iPhone:
            "iphone.gen3"
        case .pad, .iPad:
            "ipad.landscape"
        case .tv:
            "appletv.fill"
        case .carPlay:
            "car"
        case .vision:
            "rectangle.connected.to.line.below"
        case .watch:
            "watchface.applewatch.case"
        case .unspecified:
            "rectangle.connected.to.line.below"
        }
    }
    
    /// The design pattern for current device should be applied.
    @MainActor
    public static var current: DesignPattern {
#if os(macOS)
        .mac
#elseif os(visionOS)
        .vision
#elseif os(iOS)
        switch UIDevice.current.userInterfaceIdiom {
        case .unspecified:
            .unspecified
        case .phone:
            .iPhone
        case .pad:
#if targetEnvironment(macCatalyst)
            .mac
#else
            .iPad
#endif
        case .tv:
            .tv
        case .carPlay:
            .carPlay
        case .mac:
            .mac
        case .vision:
            .vision
        @unknown default:
            .unspecified
        }
#elseif os(tvOS)
        .tv
#elseif os(watchOS)
        .watch
#endif
    }
    
    @MainActor
    public static func == (lhs: DesignPattern.Type, rhs: DesignPattern) -> Bool {
        DesignPattern.current == rhs
    }
    
    /// Returns `true` if the device is *wide* is the current orientation.
    ///
    /// Depend on the device type, the device is wide when
    /// - On iPhone, landscape mode (`verticalSizeClass == .compact`)
    /// - On iPad, `horizontalSizeClass == .regular`
    /// - `true` otherwise.
    public func isExtendedHorizontal(verticalSizeClass: UserInterfaceSizeClass?, horizontalSizeClass: UserInterfaceSizeClass?) -> Bool {
        switch self {
        case .iPhone:
            verticalSizeClass == .compact // only show in landscape mode.
        case .iPad:
            horizontalSizeClass == .regular
        default:
            true // always show extended.
        }
    }
}
