//
//  SwiftUI Color.swift
//  ViewCollection
//
//  Created by Vaida on 2026-05-26.
//

import Testing
import ViewCollection
import SwiftUI


@Suite
struct SwiftUIColor {
    @Test func colorComponents() async throws {
        let _ = Color(NativeColor.gray).components
        let _ = Color(NativeColor.black).components
        let _ = Color(NativeColor(white: 0.1, alpha: 10)).components
        let _ = Color(NativeColor.red).components
    }
}
