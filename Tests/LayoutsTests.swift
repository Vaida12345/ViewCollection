//
//  LayoutsTests.swift
//  ViewCollection
//
//

import Testing
import SwiftUI
import ViewCollection


@Suite("FilledVGrid Spacing")
struct FilledVGridSpacingTests {

    // MARK: - Init

    @Test("Spacing default init")
    func defaultInit() {
        let spacing = FilledVGrid.Spacing()
        #expect(spacing.horizontal == nil)
        #expect(spacing.vertical == nil)
    }

    @Test("Spacing with horizontal only")
    func horizontalOnly() {
        let spacing = FilledVGrid.Spacing(horizontal: 10)
        #expect(spacing.horizontal == 10)
        #expect(spacing.vertical == nil)
    }

    @Test("Spacing with vertical only")
    func verticalOnly() {
        let spacing = FilledVGrid.Spacing(vertical: 20)
        #expect(spacing.horizontal == nil)
        #expect(spacing.vertical == 20)
    }

    @Test("Spacing with both")
    func bothSpacing() {
        let spacing = FilledVGrid.Spacing(horizontal: 10, vertical: 20)
        #expect(spacing.horizontal == 10)
        #expect(spacing.vertical == 20)
    }

    // MARK: - ExpressibleByFloatLiteral

    @Test("Float literal sets both")
    func floatLiteral() {
        let spacing: FilledVGrid.Spacing = 5.5
        #expect(spacing.horizontal == 5.5)
        #expect(spacing.vertical == 5.5)
    }

    @Test("Float literal zero")
    func floatLiteralZero() {
        let spacing: FilledVGrid.Spacing = 0.0
        #expect(spacing.horizontal == 0)
        #expect(spacing.vertical == 0)
    }

    // MARK: - ExpressibleByIntegerLiteral

    @Test("Integer literal sets both")
    func integerLiteral() {
        let spacing: FilledVGrid.Spacing = 5
        #expect(spacing.horizontal == 5)
        #expect(spacing.vertical == 5)
    }

    @Test("Integer literal zero")
    func integerLiteralZero() {
        let spacing: FilledVGrid.Spacing = 0
        #expect(spacing.horizontal == 0)
        #expect(spacing.vertical == 0)
    }

    // MARK: - None

    @Test("none has nil for both")
    func noneSpacing() {
        #expect(FilledVGrid.Spacing.none.horizontal == nil)
        #expect(FilledVGrid.Spacing.none.vertical == nil)
    }

    // MARK: - Equatable

    @Test("Equatable same values")
    func equatableSame() {
        let a = FilledVGrid.Spacing(horizontal: 5, vertical: 10)
        let b = FilledVGrid.Spacing(horizontal: 5, vertical: 10)
        #expect(a == b)
    }

    @Test("Equatable different values")
    func equatableDifferent() {
        let a = FilledVGrid.Spacing(horizontal: 5, vertical: 10)
        let b = FilledVGrid.Spacing(horizontal: 10, vertical: 5)
        #expect(a != b)
    }

    @Test("Equatable nil vs value")
    func equatableNilVsValue() {
        let a = FilledVGrid.Spacing()
        let b = FilledVGrid.Spacing(horizontal: 0)
        #expect(a != b)
    }

}

@Suite("EqualWidthHStack")
struct EqualWidthHStackTests {

    @Test("init with default spacing")
    func initDefaultSpacing() {
        let layout = EqualWidthHStack()
        #expect(true)
    }

    @Test("init with custom spacing")
    func initCustomSpacing() {
        let layout = EqualWidthHStack(spacing: 20)
        #expect(true)
    }

    @Test("layoutProperties stackOrientation")
    func layoutProperties() {
        #expect(EqualWidthHStack.layoutProperties.stackOrientation == .horizontal)
    }

}


@Suite("EqualWidthVStack")
struct EqualWidthVStackTests {

    @Test("init with default spacing")
    func initDefaultSpacing() {
        let layout = EqualWidthVStack()
        #expect(true)
    }

    @Test("init with custom spacing")
    func initCustomSpacing() {
        let layout = EqualWidthVStack(spacing: 20)
        #expect(true)
    }

    @Test("layoutProperties stackOrientation")
    func layoutProperties() {
        #expect(EqualWidthVStack.layoutProperties.stackOrientation == .vertical)
    }

}


@Suite("FilledVGrid")
struct FilledVGridTests {

    @Test("init with default spacing")
    func initDefaultSpacing() {
        let layout = FilledVGrid()
        #expect(true)
    }

    @Test("init with custom spacing")
    func initCustomSpacing() {
        let layout = FilledVGrid(spacing: 10)
        #expect(true)
    }

    @Test("init with Spacing type")
    func initWithSpacingType() {
        let spacing = FilledVGrid.Spacing(horizontal: 8, vertical: 12)
        let layout = FilledVGrid(spacing: spacing)
        #expect(true)
    }

}
