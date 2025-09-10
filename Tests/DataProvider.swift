//
//  DataProvider.swift
//  ViewCollection
//
//  Created by Vaida on 2025-07-05.
//

import Testing
import ViewCollection


@Suite
public struct DataProviderTest {
    
    final class Model: DataProvider {
        static var instance: DataProviderTest.Model = .load()
    }
    
    @Test func storageLocation() async throws {
        #expect(Model.storageLocation == "")
    }
    
}
