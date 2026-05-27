//
//  NativeView.swift
//  ViewCollection
//
//  Created by Vaida on 2025-12-24.
//

import Testing
import SwiftUI
import ViewCollection


@Suite("NativeViewRepresentable")
struct NativeViewRepresentableTests {

    struct _NativeViewController: NativeViewControllerRepresentable {

        func makeViewController(context: Context) -> NativeViewController {
            NativeViewController()
        }

        func updateViewController(_ viewController: NativeViewController, context: Context) {

        }

    }

    @Test func conformanceCompiles() {
        let viewController = _NativeViewController()
        #expect(true) // Compile-time verification that conformance is valid
    }

}


@Suite("NativeView")
struct NativeViewTests {

    @Test func nativeViewTypeExists() {
        // Verify the typealias compiles
        let _: NativeView.Type = NativeView.self
        #expect(true)
    }

    @Test func nativeViewControllerTypeExists() {
        let _: NativeViewController.Type = NativeViewController.self
        #expect(true)
    }

}
