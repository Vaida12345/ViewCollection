//
//  DeviceFamilyTests.swift
//  ViewCollection
//
//

import Testing
import ViewCollection
import Foundation


@Suite("DeviceFamily")
struct DeviceFamilyTests {

    // MARK: - Raw Values

    @Test("raw values are sequential UInt8")
    func rawValues() {
        #expect(DeviceFamily.MacBook.rawValue == 0)
        #expect(DeviceFamily.MacBookPro.rawValue == 1)
        #expect(DeviceFamily.MacBookAir.rawValue == 2)
        #expect(DeviceFamily.MacMini.rawValue == 3)
        #expect(DeviceFamily.MacStudio.rawValue == 4)
        #expect(DeviceFamily.iMac.rawValue == 5)
        #expect(DeviceFamily.MacPro.rawValue == 6)
        #expect(DeviceFamily.mac.rawValue == 7)
    }

    // MARK: - Identifiable

    @Test("id equals rawValue")
    func idEqualsRawValue() {
        for device in DeviceFamily.allCases {
            #expect(device.id == device.rawValue)
        }
    }

    // MARK: - CustomStringConvertible

    @Test("description MacBook")
    func descriptionMacBook() {
        #expect(DeviceFamily.MacBook.description == "MacBook")
    }

    @Test("description MacBookPro")
    func descriptionMacBookPro() {
        #expect(DeviceFamily.MacBookPro.description == "MacBook Pro")
    }

    @Test("description MacBookAir")
    func descriptionMacBookAir() {
        #expect(DeviceFamily.MacBookAir.description == "MacBook Air")
    }

    @Test("description MacMini")
    func descriptionMacMini() {
        #expect(DeviceFamily.MacMini.description == "Mac mini")
    }

    @Test("description MacStudio")
    func descriptionMacStudio() {
        #expect(DeviceFamily.MacStudio.description == "Mac Studio")
    }

    @Test("description iMac")
    func descriptionIMac() {
        #expect(DeviceFamily.iMac.description == "iMac")
    }

    @Test("description MacPro")
    func descriptionMacPro() {
        #expect(DeviceFamily.MacPro.description == "Mac Pro")
    }

    @Test("description mac")
    func descriptionMac() {
        #expect(DeviceFamily.mac.description == "Mac")
    }

    // MARK: - systemImage

    @Test("systemImage MacBook")
    func systemImageMacBook() {
        #expect(DeviceFamily.MacBook.systemImage == "macbook")
    }

    @Test("systemImage MacBookPro")
    func systemImageMacBookPro() {
        #expect(DeviceFamily.MacBookPro.systemImage == "macbook")
    }

    @Test("systemImage MacBookAir")
    func systemImageMacBookAir() {
        #expect(DeviceFamily.MacBookAir.systemImage == "macbook")
    }

    @Test("systemImage MacMini")
    func systemImageMacMini() {
        #expect(DeviceFamily.MacMini.systemImage == "macmini.gen3")
    }

    @Test("systemImage MacStudio")
    func systemImageMacStudio() {
        #expect(DeviceFamily.MacStudio.systemImage == "macstudio")
    }

    @Test("systemImage iMac")
    func systemImageIMac() {
        #expect(DeviceFamily.iMac.systemImage == "desktopcomputer")
    }

    @Test("systemImage MacPro")
    func systemImageMacPro() {
        #expect(DeviceFamily.MacPro.systemImage == "macpro.gen3")
    }

    @Test("systemImage mac")
    func systemImageMac() {
        #expect(DeviceFamily.mac.systemImage == "macbook")
    }

    // MARK: - AllCases

    @Test("allCases count")
    func allCasesCount() {
        #expect(DeviceFamily.allCases.count == 8)
    }

    @Test("allCases contains all values")
    func allCasesContainsAll() {
        let all = Set(DeviceFamily.allCases)
        #expect(all.contains(.MacBook))
        #expect(all.contains(.MacBookPro))
        #expect(all.contains(.MacBookAir))
        #expect(all.contains(.MacMini))
        #expect(all.contains(.MacStudio))
        #expect(all.contains(.iMac))
        #expect(all.contains(.MacPro))
        #expect(all.contains(.mac))
    }

    // MARK: - Codable

    @Test("Codable roundtrip")
    func codableRoundtrip() throws {
        for device in DeviceFamily.allCases {
            let encoder = JSONEncoder()
            let data = try encoder.encode(device)
            let decoder = JSONDecoder()
            let decoded = try decoder.decode(DeviceFamily.self, from: data)
            #expect(decoded == device)
        }
    }

    // MARK: - Hashable

    @Test("Hashable works in Set")
    func hashableInSet() {
        let set: Set<DeviceFamily> = [.MacBook, .MacBookPro]
        #expect(set.contains(.MacBook))
        #expect(!set.contains(.MacBookAir))
    }

    // MARK: - Sendable conformance

    @Test("Sendable conformance")
    func sendableConformance() {
        let device: DeviceFamily = .MacBookPro
        let copy = device
        #expect(copy == device)
    }

#if os(macOS)
    // MARK: - current (macOS only)

    @Test("current returns a DeviceFamily")
    func currentReturnsDeviceFamily() {
        let device = DeviceFamily.current
        #expect(DeviceFamily.allCases.contains(device))
    }
#endif

}
