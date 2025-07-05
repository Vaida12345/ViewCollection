//
//  Defaults.swift
//  ViewCollection
//
//  Created by Vaida on 2025-07-05.
//

import Testing
import SwiftUI
import ViewCollection


private extension Defaults.Key where Value == Void {
    
    var password: Defaults.Key<String> {
        .init("password", default: "none")
    }
    
}

@Test func defaultsTest() {
    let value = Defaults.standard.password
}
