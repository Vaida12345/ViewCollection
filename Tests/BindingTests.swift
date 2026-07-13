//
//  BindingTests.swift
//  ViewCollection
//
//

import Testing
import SwiftUI
import ViewCollection


@Suite("Binding Extensions")
struct BindingTests {

    // MARK: - == Operator

    @Test("Binding.== getter returns true when values match")
    func equalityGetterTrue() {
        var stored: String? = "hello"
        let binding = Binding<String?>(
            get: { stored },
            set: { stored = $0 }
        )
        let toggle = binding == "hello"
        #expect(toggle.wrappedValue == true)
    }

    @Test("Binding.== getter returns false when values differ")
    func equalityGetterFalse() {
        var stored: String? = "world"
        let binding = Binding<String?>(
            get: { stored },
            set: { stored = $0 }
        )
        let toggle = binding == "hello"
        #expect(toggle.wrappedValue == false)
    }

    @Test("Binding.== getter returns false for nil")
    func equalityGetterNil() {
        var stored: String? = nil
        let binding = Binding<String?>(
            get: { stored },
            set: { stored = $0 }
        )
        let toggle = binding == "hello"
        #expect(toggle.wrappedValue == false)
    }

    @Test("Binding.== setter true assigns rhs")
    func equalitySetterTrue() {
        var stored: String? = nil
        let binding = Binding<String?>(
            get: { stored },
            set: { stored = $0 }
        )
        let toggle = binding == "hello"
        toggle.wrappedValue = true
        #expect(stored == "hello")
    }

    @Test("Binding.== setter false assigns nil")
    func equalitySetterFalse() {
        var stored: String? = "hello"
        let binding = Binding<String?>(
            get: { stored },
            set: { stored = $0 }
        )
        let toggle = binding == "hello"
        toggle.wrappedValue = false
        #expect(stored == nil)
    }

    @Test("Binding.== with Int")
    func equalityWithInt() {
        var stored: Int? = 42
        let binding = Binding<Int?>(
            get: { stored },
            set: { stored = $0 }
        )
        let toggle = binding == 42
        #expect(toggle.wrappedValue == true)
        toggle.wrappedValue = false
        #expect(stored == nil)
        toggle.wrappedValue = true
        #expect(stored == 42)
    }

    // MARK: - != Operator

    @Test("Binding.!= getter returns true when values differ")
    func inequalityGetterTrue() {
        var stored: String? = "world"
        let binding = Binding<String?>(
            get: { stored },
            set: { stored = $0 }
        )
        let toggle = binding != "hello"
        #expect(toggle.wrappedValue == true)
    }

    @Test("Binding.!= getter returns false when values match")
    func inequalityGetterFalse() {
        var stored: String? = "hello"
        let binding = Binding<String?>(
            get: { stored },
            set: { stored = $0 }
        )
        let toggle = binding != "hello"
        #expect(toggle.wrappedValue == false)
    }

    @Test("Binding.!= getter returns true for nil")
    func inequalityGetterNil() {
        var stored: String? = nil
        let binding = Binding<String?>(
            get: { stored },
            set: { stored = $0 }
        )
        let toggle = binding != "hello"
        #expect(toggle.wrappedValue == true)
    }

    @Test("Binding.!= setter false assigns rhs")
    func inequalitySetterFalse() {
        var stored: String? = "world"
        let binding = Binding<String?>(
            get: { stored },
            set: { stored = $0 }
        )
        let toggle = binding != "hello"
        toggle.wrappedValue = false
        #expect(stored == "hello")
    }

    @Test("Binding.!= setter true assigns nil")
    func inequalitySetterTrue() {
        var stored: String? = "hello"
        let binding = Binding<String?>(
            get: { stored },
            set: { stored = $0 }
        )
        let toggle = binding != "hello"
        toggle.wrappedValue = true
        #expect(stored == nil)
    }

    // MARK: - isEqual(to:or:)

    @Test("isEqual getter returns true when equal")
    func isEqualGetterTrue() {
        var stored = "hello"
        let binding = Binding<String>(
            get: { stored },
            set: { stored = $0 }
        )
        let toggle = binding.isEqual(to: "hello", or: "fallback")
        #expect(toggle.wrappedValue == true)
    }

    @Test("isEqual getter returns false when not equal")
    func isEqualGetterFalse() {
        var stored = "world"
        let binding = Binding<String>(
            get: { stored },
            set: { stored = $0 }
        )
        let toggle = binding.isEqual(to: "hello", or: "fallback")
        #expect(toggle.wrappedValue == false)
    }

    @Test("isEqual setter true assigns other")
    func isEqualSetterTrue() {
        var stored = "world"
        let binding = Binding<String>(
            get: { stored },
            set: { stored = $0 }
        )
        let toggle = binding.isEqual(to: "hello", or: "fallback")
        toggle.wrappedValue = true
        #expect(stored == "hello")
    }

    @Test("isEqual setter false assigns falseValue")
    func isEqualSetterFalse() {
        var stored = "hello"
        let binding = Binding<String>(
            get: { stored },
            set: { stored = $0 }
        )
        let toggle = binding.isEqual(to: "hello", or: "fallback")
        toggle.wrappedValue = false
        #expect(stored == "fallback")
    }

    @Test("isEqual with Int")
    func isEqualWithInt() {
        var stored = 10
        let binding = Binding<Int>(
            get: { stored },
            set: { stored = $0 }
        )
        let toggle = binding.isEqual(to: 10, or: -1)
        #expect(toggle.wrappedValue == true)
        toggle.wrappedValue = false
        #expect(stored == -1)
    }

    // MARK: - CGFloat.double

    @Test("CGFloat binding double getter")
    func cgFloatDoubleGetter() {
        let binding = Binding<CGFloat>(
            get: { 3.14 },
            set: { _ in }
        )
        let doubleBinding = binding.double
        #expect(doubleBinding.wrappedValue == 3.14)
    }

    @Test("CGFloat binding double setter")
    func cgFloatDoubleSetter() {
        var stored: CGFloat = 0
        let binding = Binding<CGFloat>(
            get: { stored },
            set: { stored = $0 }
        )
        let doubleBinding = binding.double
        doubleBinding.wrappedValue = 2.718
        #expect(stored == 2.718)
    }

    // MARK: - CGFloat.float (deprecated)

    @Test("CGFloat binding float getter")
    func cgFloatFloatGetter() {
        let binding = Binding<CGFloat>(
            get: { 1.5 },
            set: { _ in }
        )
        let floatBinding = binding.double
        #expect(floatBinding.wrappedValue == 1.5)
    }

    @Test("CGFloat binding float setter")
    func cgFloatFloatSetter() {
        var stored: CGFloat = 0
        let binding = Binding<CGFloat>(
            get: { stored },
            set: { stored = $0 }
        )
        let floatBinding = binding.double
        floatBinding.wrappedValue = 2.5
        #expect(stored == 2.5)
    }

    // MARK: - Edge Cases

    @Test("Binding.== with nested Optional nil")
    func equalityNestedNil() {
        var stored: String?? = nil
        let binding = Binding<String??>(
            get: { stored },
            set: { stored = $0 }
        )
        let toggle = binding == nil
        #expect(toggle.wrappedValue == true)
    }

    @Test("Binding.!= with nested Optional nil")
    func inequalityNestedNil() {
        var stored: String?? = "hello"
        let binding = Binding<String??>(
            get: { stored },
            set: { stored = $0 }
        )
        let toggle = binding != nil
        #expect(toggle.wrappedValue == true)
    }

}
