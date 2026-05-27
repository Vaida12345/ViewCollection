//
//  ExtensionsTests.swift
//  ViewCollection
//
//

import Testing
import SwiftUI
import ViewCollection


@Suite("EverySecondTimelineSchedule")
struct EverySecondTimelineScheduleTests {

    @Test("static everySecond property")
    func staticEverySecond() {
        let schedule = EverySecondTimelineSchedule.everySecond
        #expect(type(of: schedule) == EverySecondTimelineSchedule.self)
    }

    @Test("entries normal mode fires every second")
    func entriesNormalMode() {
        let schedule = EverySecondTimelineSchedule.everySecond
        let startDate = Date(timeIntervalSinceReferenceDate: 0)
        let entries = schedule.entries(from: startDate, mode: .normal)

        var iterator = entries.makeIterator()
        let first = iterator.next()
        let second = iterator.next()
        let third = iterator.next()

        #expect(first == startDate)
        #expect(second?.timeIntervalSince(first!) == 1.0)
        #expect(third?.timeIntervalSince(second!) == 1.0)
    }

    @Test("entries low frequency mode fires every 60 seconds")
    func entriesLowFrequencyMode() {
        let schedule = EverySecondTimelineSchedule.everySecond
        let startDate = Date(timeIntervalSinceReferenceDate: 0)
        let entries = schedule.entries(from: startDate, mode: .lowFrequency)

        var iterator = entries.makeIterator()
        let first = iterator.next()
        let second = iterator.next()
        let third = iterator.next()

        #expect(first == startDate)
        #expect(second?.timeIntervalSince(first!) == 60.0)
        #expect(third?.timeIntervalSince(second!) == 60.0)
    }

    @Test("entries sequence is infinite")
    func entriesSequenceIsInfinite() {
        let schedule = EverySecondTimelineSchedule.everySecond
        let startDate = Date()
        let entries = schedule.entries(from: startDate, mode: .normal)

        var count = 0
        var iterator = entries.makeIterator()
        while count < 100, iterator.next() != nil {
            count += 1
        }
        #expect(count == 100)
    }

}


@Suite("GridItem Extension")
struct GridItemExtensionTests {

    @Test("fixed creates GridItem with fixed size")
    func fixedGridItem() {
        let item = GridItem.fixed(100)
        if #available(macOS 26.0, *) {
            #expect(item.size == .fixed(100))
        }
    }

    @Test("fixed with zero size")
    func fixedZeroSize() {
        let item = GridItem.fixed(0)
        if #available(macOS 26.0, *) {
            #expect(item.size == .fixed(0))
        }
    }

    @Test("fixed with fractional value")
    func fixedFractionalSize() {
        let item = GridItem.fixed(50.5)
        if #available(macOS 26.0, *) {
            #expect(item.size == .fixed(50.5))
        }
    }

}


@Suite("withoutAnimation")
struct WithoutAnimationTests {

    @Test("withoutAnimation executes action")
    func withoutAnimationExecutes() {
        var called = false
        withoutAnimation {
            called = true
        }
        #expect(called)
    }

    @Test("withoutAnimation returns value")
    func withoutAnimationReturnsValue() {
        let result = withoutAnimation { 42 }
        #expect(result == 42)
    }

    @Test("withoutAnimation rethrows")
    func withoutAnimationRethrows() {
        struct TestError: Error {}
        #expect(throws: TestError.self) {
            try withoutAnimation {
                throw TestError()
            }
        }
    }

    @Test("withoutAnimation does not throw on success")
    func withoutAnimationDoesNotThrow() {
        #expect(throws: Never.self) {
            try withoutAnimation {
                // no throw
            }
        }
    }

}


@Suite("ProcessInfo isPreview")
struct ProcessInfoTests {

    @Test("isPreview is Bool")
    func isPreviewIsBool() {
        let value = ProcessInfo.processInfo.isPreview
        // In test environment (non-DEBUG or DEBUG without previews), should be false
        #expect(value == false)
    }

}


@Suite("Label Extension")
struct LabelExtensionTests {

    @Test("Label init with localization")
    func labelInitWithLocalization() {
        let label = Label("Test", systemImage: "star", tableName: nil, bundle: nil, comment: nil)
        #expect(type(of: label) == Label<Text, Image>.self)
    }

}
