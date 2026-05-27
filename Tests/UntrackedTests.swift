//
//  UntrackedTests.swift
//  ViewCollection
//
//

import Testing
import ViewCollection


@Suite("Untracked Property Wrapper")
struct UntrackedTests {

    // MARK: - Basic Operations

    @Test("init with wrappedValue")
    func initWrappedValue() {
        let untracked = Untracked(wrappedValue: 42)
        #expect(untracked.wrappedValue == 42)
    }

    @Test("wrappedValue get and set")
    func wrappedValueGetSet() {
        let untracked = Untracked(wrappedValue: "hello")
        #expect(untracked.wrappedValue == "hello")
        untracked.wrappedValue = "world"
        #expect(untracked.wrappedValue == "world")
    }

    // MARK: - Type Support

    @Test("Int value")
    func intValue() {
        let untracked = Untracked(wrappedValue: 0)
        #expect(untracked.wrappedValue == 0)
        untracked.wrappedValue = 100
        #expect(untracked.wrappedValue == 100)
    }

    @Test("String value")
    func stringValue() {
        let untracked = Untracked(wrappedValue: "")
        #expect(untracked.wrappedValue == "")
        untracked.wrappedValue = "Hello, World!"
        #expect(untracked.wrappedValue == "Hello, World!")
    }

    @Test("Double value")
    func doubleValue() {
        let untracked = Untracked(wrappedValue: 3.14)
        #expect(untracked.wrappedValue == 3.14)
    }

    @Test("Bool value")
    func boolValue() {
        let untracked = Untracked(wrappedValue: true)
        #expect(untracked.wrappedValue == true)
        untracked.wrappedValue = false
        #expect(untracked.wrappedValue == false)
    }

    @Test("Optional value")
    func optionalValue() {
        let untracked = Untracked<Int?>(wrappedValue: nil)
        #expect(untracked.wrappedValue == nil)
        untracked.wrappedValue = 42
        #expect(untracked.wrappedValue == 42)
        untracked.wrappedValue = nil
        #expect(untracked.wrappedValue == nil)
    }

    @Test("Array value")
    func arrayValue() {
        let untracked = Untracked(wrappedValue: [1, 2, 3])
        #expect(untracked.wrappedValue == [1, 2, 3])
        untracked.wrappedValue.append(4)
        #expect(untracked.wrappedValue == [1, 2, 3, 4])
    }

    @Test("Dictionary value")
    func dictionaryValue() {
        let untracked = Untracked(wrappedValue: ["a": 1, "b": 2])
        #expect(untracked.wrappedValue == ["a": 1, "b": 2])
        untracked.wrappedValue["c"] = 3
        #expect(untracked.wrappedValue["c"] == 3)
    }

    // MARK: - Struct Value

    struct TestStruct {
        var value: Int
    }

    @Test("Struct value")
    func structValue() {
        let untracked = Untracked(wrappedValue: TestStruct(value: 10))
        #expect(untracked.wrappedValue.value == 10)
        untracked.wrappedValue.value = 20
        #expect(untracked.wrappedValue.value == 20)
    }

}
