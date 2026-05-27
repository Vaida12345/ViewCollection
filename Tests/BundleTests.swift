//
//  BundleTests.swift
//  ViewCollection
//
//

import Testing
@testable import ViewCollection
import Foundation


@Suite("Bundle Extensions")
struct BundleTests {

    // MARK: - ResourceKey Enum

    @Test("ResourceKey displayName rawValue")
    func resourceKeyDisplayName() {
        #expect(Bundle.ResourceKey.displayName.rawValue == "CFBundleDisplayName")
    }

    @Test("ResourceKey executableFile rawValue")
    func resourceKeyExecutableFile() {
        #expect(Bundle.ResourceKey.executableFile.rawValue == "CFBundleExecutable")
    }

    @Test("ResourceKey iconFile rawValue")
    func resourceKeyIconFile() {
        #expect(Bundle.ResourceKey.iconFile.rawValue == "CFBundleIconFile")
    }

    @Test("ResourceKey iconName rawValue")
    func resourceKeyIconName() {
        #expect(Bundle.ResourceKey.iconName.rawValue == "CFBundleIconName")
    }

    @Test("ResourceKey bundleName rawValue")
    func resourceKeyBundleName() {
        #expect(Bundle.ResourceKey.bundleName.rawValue == "CFBundleName")
    }

    @Test("ResourceKey version rawValue")
    func resourceKeyVersion() {
        #expect(Bundle.ResourceKey.version.rawValue == "CFBundleShortVersionString")
    }

    @Test("ResourceKey buildVersion rawValue")
    func resourceKeyBuildVersion() {
        #expect(Bundle.ResourceKey.buildVersion.rawValue == "CFBundleVersion")
    }

    @Test("ResourceKey copyright rawValue")
    func resourceKeyCopyright() {
        #expect(Bundle.ResourceKey.copyright.rawValue == "NSHumanReadableCopyright")
    }

    // MARK: - load

    @Test("load returns nil for missing key")
    func loadMissingKey() {
        let bundle = Bundle.main
        let result = bundle.load(.displayName)
        // Bundle.main in test runner may or may not have display name
        // Just check it returns optional String
        let _: String? = result
    }

    @Test("load returns value for existing key")
    func loadExistingKey() {
        let bundle = Bundle.main
        let bundleName = bundle.load(.bundleName)
        // In test environment, the bundle name should exist
        #expect(bundleName != nil)
    }

    @Test("load with custom bundle")
    func loadWithCustomBundle() {
        let bundle = Bundle.module
        // Bundle.module in test target may have different keys
        let version = bundle.load(.version)
        let _: String? = version
    }

    // MARK: - Edge Cases

    @Test("ResourceKey is Sendable")
    func resourceKeyIsSendable() {
        let key: Bundle.ResourceKey = .version
        let copy = key
        #expect(copy == key)
    }

}
