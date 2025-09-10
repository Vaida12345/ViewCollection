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
    @Test func mix() async throws {
        let lhs = NSColor(red: 0, green: 0, blue: 0, alpha: 1)
        let rhs = NSColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
        
        #expect(lhs.mix(with: rhs, by: 0.5) == NSColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1))
    }
#endif
    
    @Test func components() {
        let date = Date()
        var i = 0
        while i < 1000_000 {
            _ = Color.red.components
            i += 1
        }
        print(date.distanceToNow())
    }
    
}
