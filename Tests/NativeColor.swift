//
//  NativeColor.swift
//  ViewCollection
//
//  Created by Vaida on 2025-06-28.
//

import Testing
import ViewCollection
import AppKit


@Suite("NativeColor")
public struct NativeColorTests {
    
    @Test func mix() async throws {
        let lhs = NSColor(red: 0, green: 0, blue: 0, alpha: 1)
        let rhs = NSColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
        
        #expect(lhs.mix(with: rhs, by: 0.5) == NSColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1))
    }
    
}
