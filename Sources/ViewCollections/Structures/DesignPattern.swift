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
    case mac, phone, pad, tv, carPlay, vision, watch
    
    /// The unspecified can be matched against any pattern
    case unspecified
    
    public var isMac:     Bool { self == .mac }
    public var isPhone:   Bool { self == .phone }
    public var isPad:     Bool { self == .pad }
    public var isTV:      Bool { self == .tv }
    public var isCarPlay: Bool { self == .carPlay }
    public var isReality: Bool { self == .vision }
    
    /// Whether the pattern is `mac`, `pad`, `tv`, `reality` or `unspecified`.
    @inlinable
    public var isLargeScreen: Bool {
        switch self {
        case .mac, .pad, .tv, .vision, .unspecified:
            true
        default:
            false
        }
    }
    
    /// The device name
    @inlinable
    public var deviceName: String {
        switch self {
        case .mac:
            "Mac"
        case .phone:
            "iPhone"
        case .pad:
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
            if #available(macOS 14, iOS 17, macCatalyst 17, tvOS 17, watchOS 10, *) {
                "macbook"
            } else {
                "laptopcomputer"
            }
        case .phone:
            "iphone.gen3"
        case .pad:
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
            .phone
        case .pad:
#if targetEnvironment(macCatalyst)
            .mac
#else
            .pad
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
}
