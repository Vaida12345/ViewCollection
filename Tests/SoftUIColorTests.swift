//
//  SoftUIColorTests.swift
//  ViewCollection
//
//

import Testing
import SwiftUI
import ViewCollection
import SoftUI


@Suite("SoftUI Colors")
struct SoftUIColorTests {

    // MARK: - Color.Soft.main

    @Test("main returns a Color")
    func mainReturnsColor() {
        let color = Color.Soft.main
        #expect(type(of: color) == Color.self)
    }

    @Test("main has valid components")
    func mainHasValidComponents() {
        let components = Color.Soft.main.components
        #expect(components[0] >= 0 && components[0] <= 1)
        #expect(components[1] >= 0 && components[1] <= 1)
        #expect(components[2] >= 0 && components[2] <= 1)
        #expect(components[3] == 1.0)
    }

    // MARK: - Color.Soft.secondary

    @Test("secondary returns a Color")
    func secondaryReturnsColor() {
        let color = Color.Soft.secondary
        #expect(type(of: color) == Color.self)
    }

    @Test("secondary has valid components")
    func secondaryHasValidComponents() {
        let components = Color.Soft.secondary.components
        #expect(components[0] >= 0 && components[0] <= 1)
        #expect(components[1] >= 0 && components[1] <= 1)
        #expect(components[2] >= 0 && components[2] <= 1)
        #expect(components[3] == 1.0)
    }

    // MARK: - Color.Soft.fill

    @Test("fill returns a Color")
    func fillReturnsColor() {
        let color = Color.Soft.fill
        #expect(type(of: color) == Color.self)
    }

    @Test("fill has valid components")
    func fillHasValidComponents() {
        let components = Color.Soft.fill.components
        #expect(components[0] >= 0 && components[0] <= 1)
        #expect(components[1] >= 0 && components[1] <= 1)
        #expect(components[2] >= 0 && components[2] <= 1)
        #expect(components[3] == 1.0)
    }

    // MARK: - Color.Soft.lightShadow

    @Test("lightShadow returns a Color")
    func lightShadowReturnsColor() {
        let color = Color.Soft.lightShadow
        #expect(type(of: color) == Color.self)
    }

    @Test("lightShadow has valid components")
    func lightShadowHasValidComponents() {
        let components = Color.Soft.lightShadow.components
        #expect(components[0] >= 0 && components[0] <= 1)
        #expect(components[1] >= 0 && components[1] <= 1)
        #expect(components[2] >= 0 && components[2] <= 1)
        #expect(components[3] == 1.0)
    }

    // MARK: - Color.Soft.darkShadow

    @Test("darkShadow returns a Color")
    func darkShadowReturnsColor() {
        let color = Color.Soft.darkShadow
        #expect(type(of: color) == Color.self)
    }

    @Test("darkShadow has valid components")
    func darkShadowHasValidComponents() {
        let components = Color.Soft.darkShadow.components
        #expect(components[0] >= 0 && components[0] <= 1)
        #expect(components[1] >= 0 && components[1] <= 1)
        #expect(components[2] >= 0 && components[2] <= 1)
        #expect(components[3] == 1.0)
    }

    // MARK: - All SoftUI colors are distinct

    @Test("all soft colors are distinct")
    func allSoftColorsDistinct() {
        let colors: [Color] = [
            .Soft.main,
            .Soft.secondary,
            .Soft.fill,
            .Soft.lightShadow,
            .Soft.darkShadow,
        ]
        let ids = colors.map(\.id)
        #expect(Set(ids).count == colors.count)
    }

    // MARK: - Color.soft accessor

    @Test("Color.soft returns Soft.Type")
    func colorSoftReturnsSoftType() {
        #expect(Color.soft == Color.Soft.self)
    }

}
