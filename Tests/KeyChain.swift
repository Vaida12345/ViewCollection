//
//  KeyChain.swift
//  ViewCollection
//
//  Created by Vaida on 2025-07-05.
//

import Testing
import SwiftUI
import ViewCollection


private extension KeyChain.Key where Value == Void {
    
    var password: KeyChain.Key<String> {
        .init("password")
    }
    
}

@Test func keyChainTest() {
    let value = KeyChain.standard.password
}
