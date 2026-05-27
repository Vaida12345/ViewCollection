//
//  NativeColor.swift
//  ViewCollection
//
//  Created by Vaida on 2025-06-28.
//

import Testing
import ViewCollection
import SwiftUI
#if canImport(AppKit)
import AppKit
#endif


@Suite("NativeColor")
public struct NativeColorTests {

#if canImport(AppKit)
    @Test func mixBlackAndWhite() async throws {
        let lhs = NSColor(red: 0, green: 0, blue: 0, alpha: 1)
        let rhs = NSColor(red: 1, green: 1, blue: 1, alpha: 1)

        let result = lhs.mix(with: rhs, by: 0.5)
        #expect(result == NSColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1))
    }

    @Test func mixSameColor() async throws {
        let color = NSColor(red: 0.2, green: 0.4, blue: 0.6, alpha: 1)
        let result = color.mix(with: color, by: 0.3)
        #expect(result == color)
    }

    @Test func mixZeroFraction() async throws {
        let lhs = NSColor(red: 0.1, green: 0.2, blue: 0.3, alpha: 0.5)
        let rhs = NSColor(red: 0.9, green: 0.8, blue: 0.7, alpha: 1.0)

        let result = lhs.mix(with: rhs, by: 0)
        #expect(result == lhs)
    }

    @Test func mixFullFraction() async throws {
        let lhs = NSColor(red: 0.1, green: 0.2, blue: 0.3, alpha: 0.5)
        let rhs = NSColor(red: 0.9, green: 0.8, blue: 0.7, alpha: 1.0)

        let result = lhs.mix(with: rhs, by: 1)
        #expect(result == rhs)
    }

    @Test func mixPartialAlpha() async throws {
        let lhs = NSColor(red: 0, green: 0, blue: 0, alpha: 0)
        let rhs = NSColor(red: 1, green: 1, blue: 1, alpha: 1)

        let result = lhs.mix(with: rhs, by: 0.5)
        #expect(result == NSColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5))
    }
#endif

    @Test func colorComponentsPerformance() {
        var i = 0
        while i < 100_000 {
            _ = Color.red.components
            i += 1
        }
    }

}
