//
//  MutableBindingTests.swift
//  ViewCollection
//
//

import Testing
import SwiftUI
import ViewCollection


@Suite("MutableBinding")
@MainActor
struct MutableBindingTests {

    // MARK: - Basic Operations

    @Test("get returns value")
    func getReturnsValue() {
        var stored = "hello"
        let binding = Binding<String>(
            get: { stored },
            set: { stored = $0 }
        )
        let mutable = MutableBinding(content: binding)
        #expect(mutable.get() == "hello")
    }

    @Test("set updates value")
    func setUpdatesValue() {
        var stored = "hello"
        let binding = Binding<String>(
            get: { stored },
            set: { stored = $0 }
        )
        let mutable = MutableBinding(content: binding)
        mutable.set("world")
        #expect(stored == "world")
        #expect(mutable.get() == "world")
    }

    @Test("wrappedValue get")
    func wrappedValueGet() {
        var stored = 42
        let binding = Binding<Int>(
            get: { stored },
            set: { stored = $0 }
        )
        let mutable = MutableBinding(content: binding)
        #expect(mutable.wrappedValue == 42)
    }

    @Test("wrappedValue set")
    func wrappedValueSet() {
        var stored = 42
        let binding = Binding<Int>(
            get: { stored },
            set: { stored = $0 }
        )
        let mutable = MutableBinding(content: binding)
        mutable.wrappedValue = 99
        #expect(stored == 99)
    }

    // MARK: - Binding.mutable

    @Test("Binding.mutable creates MutableBinding")
    func bindingMutable() {
        var stored = "test"
        let binding = Binding<String>(
            get: { stored },
            set: { stored = $0 }
        )
        let mutable = binding.mutable
        #expect(mutable.wrappedValue == "test")
        mutable.wrappedValue = "updated"
        #expect(stored == "updated")
    }

    // MARK: - Edge Cases

    @Test("optional value")
    func optionalValue() {
        var stored: Int? = nil
        let binding = Binding<Int?>(
            get: { stored },
            set: { stored = $0 }
        )
        let mutable = MutableBinding(content: binding)
        #expect(mutable.wrappedValue == nil)
        mutable.wrappedValue = 42
        #expect(stored == 42)
    }

    @Test("Bool value")
    func boolValue() {
        var stored = false
        let binding = Binding<Bool>(
            get: { stored },
            set: { stored = $0 }
        )
        let mutable = MutableBinding(content: binding)
        #expect(mutable.wrappedValue == false)
        mutable.wrappedValue = true
        #expect(stored == true)
    }

    @Test("Double value")
    func doubleValue() {
        var stored = 3.14
        let binding = Binding<Double>(
            get: { stored },
            set: { stored = $0 }
        )
        let mutable = MutableBinding(content: binding)
        #expect(mutable.wrappedValue == 3.14)
        mutable.wrappedValue = 2.718
        #expect(stored == 2.718)
    }

}
