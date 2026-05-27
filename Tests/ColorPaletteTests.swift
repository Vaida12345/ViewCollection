//
//  ColorPaletteTests.swift
//  ViewCollection
//
//

import Testing
import SwiftUI
import ViewCollection


@Suite("ColorPalette")
struct ColorPaletteTests {

    // MARK: - Blue

    @Test("blue dark returns 5 colors")
    func blueDarkCount() {
        let colors = ColorPalette.blue(of: .dark)
        #expect(colors.count == 5)
    }

    @Test("blue light returns 7 colors")
    func blueLightCount() {
        let colors = ColorPalette.blue(of: .light)
        #expect(colors.count == 7)
    }

    @Test("blue pure returns 5 colors")
    func bluePureCount() {
        let colors = ColorPalette.blue(of: .pure)
        #expect(colors.count == 5)
    }

    @Test("blue dark all unique")
    func blueDarkUnique() {
        let colors = ColorPalette.blue(of: .dark)
        let ids = colors.map(\.id)
        #expect(Set(ids).count == colors.count)
    }

    @Test("blue light all unique")
    func blueLightUnique() {
        let colors = ColorPalette.blue(of: .light)
        let ids = colors.map(\.id)
        #expect(Set(ids).count == colors.count)
    }

    // MARK: - Green

    @Test("green dark returns 6 colors")
    func greenDarkCount() {
        let colors = ColorPalette.green(of: .dark)
        #expect(colors.count == 6)
    }

    @Test("green light returns 5 colors")
    func greenLightCount() {
        let colors = ColorPalette.green(of: .light)
        #expect(colors.count == 5)
    }

    @Test("green dark all unique")
    func greenDarkUnique() {
        let colors = ColorPalette.green(of: .dark)
        let ids = colors.map(\.id)
        #expect(Set(ids).count == colors.count)
    }

    @Test("green light all unique")
    func greenLightUnique() {
        let colors = ColorPalette.green(of: .light)
        let ids = colors.map(\.id)
        #expect(Set(ids).count == colors.count)
    }

    // MARK: - Orange

    @Test("orange returns 6 colors")
    func orangeCount() {
        let colors = ColorPalette.orange()
        #expect(colors.count == 6)
    }

    @Test("orange all unique")
    func orangeUnique() {
        let colors = ColorPalette.orange()
        let ids = colors.map(\.id)
        #expect(Set(ids).count == colors.count)
    }

    // MARK: - Pink

    @Test("pink dark returns 5 colors")
    func pinkDarkCount() {
        let colors = ColorPalette.pink(of: .dark)
        #expect(colors.count == 5)
    }

    @Test("pink light returns 5 colors")
    func pinkLightCount() {
        let colors = ColorPalette.pink(of: .light)
        #expect(colors.count == 5)
    }

    @Test("pink dark all unique")
    func pinkDarkUnique() {
        let colors = ColorPalette.pink(of: .dark)
        let ids = colors.map(\.id)
        #expect(Set(ids).count == colors.count)
    }

    @Test("pink light all unique")
    func pinkLightUnique() {
        let colors = ColorPalette.pink(of: .light)
        let ids = colors.map(\.id)
        #expect(Set(ids).count == colors.count)
    }

    // MARK: - Variation Enums

    @Test("BlueVariations allCases count")
    func blueVariationsAllCases() {
        #expect(ColorPalette.BlueVariations.allCases.count == 3)
    }

    @Test("BlueVariations contains dark")
    func blueVariationsContainsDark() {
        #expect(ColorPalette.BlueVariations.allCases.contains(.dark))
    }

    @Test("BlueVariations contains light")
    func blueVariationsContainsLight() {
        #expect(ColorPalette.BlueVariations.allCases.contains(.light))
    }

    @Test("BlueVariations contains pure")
    func blueVariationsContainsPure() {
        #expect(ColorPalette.BlueVariations.allCases.contains(.pure))
    }

    @Test("BlueVariations raw values")
    func blueVariationsRawValues() {
        #expect(ColorPalette.BlueVariations.dark.rawValue == "Dark Blue")
        #expect(ColorPalette.BlueVariations.light.rawValue == "Light Blue")
        #expect(ColorPalette.BlueVariations.pure.rawValue == "Pure Blue")
    }

    @Test("GreenVariations allCases count")
    func greenVariationsAllCases() {
        #expect(ColorPalette.GreenVariations.allCases.count == 2)
    }

    @Test("GreenVariations contains dark")
    func greenVariationsContainsDark() {
        #expect(ColorPalette.GreenVariations.allCases.contains(.dark))
    }

    @Test("GreenVariations contains light")
    func greenVariationsContainsLight() {
        #expect(ColorPalette.GreenVariations.allCases.contains(.light))
    }

    @Test("GreenVariations raw values")
    func greenVariationsRawValues() {
        #expect(ColorPalette.GreenVariations.dark.rawValue == "Dark Green")
        #expect(ColorPalette.GreenVariations.light.rawValue == "Light Green")
    }

    @Test("PinkVariations allCases count")
    func pinkVariationsAllCases() {
        #expect(ColorPalette.PinkVariations.allCases.count == 2)
    }

    @Test("PinkVariations contains dark")
    func pinkVariationsContainsDark() {
        #expect(ColorPalette.PinkVariations.allCases.contains(.dark))
    }

    @Test("PinkVariations contains light")
    func pinkVariationsContainsLight() {
        #expect(ColorPalette.PinkVariations.allCases.contains(.light))
    }

    @Test("PinkVariations raw values")
    func pinkVariationsRawValues() {
        #expect(ColorPalette.PinkVariations.dark.rawValue == "Dark Pink")
        #expect(ColorPalette.PinkVariations.light.rawValue == "Light Pink")
    }

    // MARK: - Edge Cases

    @Test("all colors have valid components")
    func allColorsHaveValidComponents() {
        let allVariations: [[Color]] = [
            ColorPalette.blue(of: .dark),
            ColorPalette.blue(of: .light),
            ColorPalette.blue(of: .pure),
            ColorPalette.green(of: .dark),
            ColorPalette.green(of: .light),
            ColorPalette.orange(),
            ColorPalette.pink(of: .dark),
            ColorPalette.pink(of: .light),
        ]
        for colors in allVariations {
            for color in colors {
                let components = color.components
                #expect(components[0] >= 0 && components[0] <= 1)
                #expect(components[1] >= 0 && components[1] <= 1)
                #expect(components[2] >= 0 && components[2] <= 1)
                #expect(components[3] == 1.0)
            }
        }
    }

    @Test("variation enums are Hashable")
    func variationEnumsHashable() {
        let set: Set<ColorPalette.BlueVariations> = [.dark, .light]
        #expect(set.contains(.dark))
        #expect(set.contains(.light))
        #expect(!set.contains(.pure))
    }

    @Test("variation enums are Identifiable")
    func variationEnumsIdentifiable() {
        let dark = ColorPalette.BlueVariations.dark
        #expect(dark.id == dark.rawValue)
    }

}
