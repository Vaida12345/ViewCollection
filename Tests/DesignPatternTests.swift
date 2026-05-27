//
//  DesignPatternTests.swift
//  ViewCollection
//
//

import Testing
import ViewCollection
import Foundation


@Suite("DesignPattern")
struct DesignPatternTests {

    // MARK: - current

    @Test("current returns a DesignPattern")
    @MainActor
    func currentReturnsDesignPattern() {
        let pattern = DesignPattern.current
        // On macOS, should be .mac
        #if os(macOS)
        #expect(pattern == .mac)
        #endif
    }

    // MARK: - Codable

    @Test("Codable roundtrip")
    func codableRoundtrip() throws {
        let original = DesignPattern.mac
        let encoder = JSONEncoder()
        let data = try encoder.encode(original)
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(DesignPattern.self, from: data)
        #expect(decoded == original)
    }

    @Test("Codable all cases roundtrip")
    func codableAllCasesRoundtrip() throws {
        let cases: [DesignPattern] = [.mac, .iPad, .iPhone, .tv, .carPlay, .vision, .watch, .unspecified]
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        for original in cases {
            let data = try encoder.encode(original)
            let decoded = try decoder.decode(DesignPattern.self, from: data)
            #expect(decoded == original)
        }
    }

}
