//
//  DataProvider.swift
//  ViewCollection
//
//  Created by Vaida on 2025-07-05.
//

import Testing
import ViewCollection
import FinderItem
import Foundation


@Suite("DataProvider")
public struct DataProviderTest {

    final class Model: DataProvider {
        var payload = UUID()
        static var instance: DataProviderTest.Model = .load()
    }

    @Test func storageLocation() async throws {
        let location = Model.storageLocation
        #expect(location.path.hasSuffix("Model.plist"))
        #expect(location.path.contains("DataProviders"))
    }

    @Test func storageLocationIsAbsolute() async throws {
        let location = Model.storageLocation
        #expect(location.path.hasPrefix("/"))
    }

    @Test func saveAndLoad() async throws {
        let model = Model()
        try model.save()
        let loaded = Model.load()
        #expect(loaded.payload == model.payload)
    }

}
