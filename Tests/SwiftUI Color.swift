//
//  SwiftUI Color.swift
//  ViewCollection
//
//  Created by Vaida on 2026-05-26.
//

import Testing
import ViewCollection
import SwiftUI
import simd
#if canImport(AppKit)
import AppKit
#endif
#if canImport(UIKit)
import UIKit
#endif


@Suite("SwiftUI Color")
struct SwiftUIColorTests {

    // MARK: - Components

    @Test func colorComponents() async throws {
        let _ = Color(NativeColor.gray).components
        let _ = Color(NativeColor.black).components
        let _ = Color(NativeColor(white: 0.1, alpha: 10)).components
        let _ = Color(NativeColor.red).components
    }

    @Test func redComponents() async throws {
        let components = Color(.sRGB, red: 1, green: 0, blue: 0).components
        #expect(components[0] == 1.0)
        #expect(components[1] == 0.0)
        #expect(components[2] == 0.0)
        #expect(components[3] == 1.0)
    }

    @Test func greenComponents() async throws {
        let components = Color(.sRGB, red: 0, green: 1, blue: 0).components
        #expect(components[0] == 0.0)
        #expect(components[1] == 1.0)
        #expect(components[2] == 0.0)
        #expect(components[3] == 1.0)
    }

    @Test func blueComponents() async throws {
        let components = Color(.sRGB, red: 0, green: 0, blue: 1).components
        #expect(components[0] == 0.0)
        #expect(components[1] == 0.0)
        #expect(components[2] == 1.0)
        #expect(components[3] == 1.0)
    }

    @Test func blackComponents() async throws {
        let components = Color.black.components
        #expect(components[0] == 0.0)
        #expect(components[1] == 0.0)
        #expect(components[2] == 0.0)
        #expect(components[3] == 1.0)
    }

    @Test func whiteComponents() async throws {
        let components = Color.white.components
        #expect(components[0] == 1.0)
        #expect(components[1] == 1.0)
        #expect(components[2] == 1.0)
        #expect(components[3] == 1.0)
    }

    // MARK: - Components Robustness

    /// sRGB color with explicit values should roundtrip exactly.
    @Test func sRGBExplicitValues() async throws {
        let color = Color(.sRGB, red: 0.2, green: 0.4, blue: 0.6, opacity: 0.8)
        let components = color.components
        #expect(abs(components[0] - 0.2) < 0.001)
        #expect(abs(components[1] - 0.4) < 0.001)
        #expect(abs(components[2] - 0.6) < 0.001)
        #expect(abs(components[3] - 0.8) < 0.001)
    }

    /// sRGB color, all channels near zero.
    @Test func sRGBNearBlack() async throws {
        let color = Color(.sRGB, red: 0.01, green: 0.02, blue: 0.03, opacity: 1.0)
        let components = color.components
        #expect(abs(components[0] - 0.01) < 0.001)
        #expect(abs(components[1] - 0.02) < 0.001)
        #expect(abs(components[2] - 0.03) < 0.001)
        #expect(components[3] == 1.0)
    }

    /// sRGB color, all channels near one.
    @Test func sRGBNearWhite() async throws {
        let color = Color(.sRGB, red: 0.98, green: 0.99, blue: 0.97, opacity: 0.5)
        let components = color.components
        #expect(abs(components[0] - 0.98) < 0.001)
        #expect(abs(components[1] - 0.99) < 0.001)
        #expect(abs(components[2] - 0.97) < 0.001)
        #expect(abs(components[3] - 0.5) < 0.001)
    }

    /// displayP3 color should be converted to sRGB by the components getter.
    @Test func displayP3Components() async throws {
        let color = Color(.displayP3, red: 1.0, green: 0.0, blue: 0.0, opacity: 1.0)
        let components = color.components
        // P3 red (1,0,0) in sRGB is approximately (1.0, -0.0, 0.0) — may clip
        #expect(components[0] >= 0.9) // Should still be predominantly red
        #expect(components[3] == 1.0)
    }

    /// displayP3 green converted to sRGB.
    @Test func displayP3GreenToSRGB() async throws {
        let color = Color(.displayP3, red: 0.0, green: 1.0, blue: 0.0, opacity: 1.0)
        let components = color.components
        // P3 green is slightly outside sRGB gamut
        #expect(components[1] >= 0.9)
        #expect(components[3] == 1.0)
    }

    /// displayP3 with mid-range values.
    @Test func displayP3MidRange() async throws {
        let color = Color(.displayP3, red: 0.3, green: 0.6, blue: 0.9, opacity: 0.7)
        let components = color.components
        // Values should be reasonably close after conversion to sRGB
        #expect(abs(components[0] - 0.3) < 0.2)
        #expect(abs(components[1] - 0.6) < 0.1)
        #expect(abs(components[2] - 0.9) < 0.1)
        #expect(abs(components[3] - 0.7) < 0.02)
    }

    /// Gray-scale Color(white:) should produce R=G=B.
    @Test func grayscaleColor() async throws {
        let color = Color(white: 0.5)
        let components = color.components
        #expect(abs(components[0] - 0.5) < 0.01)
        #expect(abs(components[1] - 0.5) < 0.01)
        #expect(abs(components[2] - 0.5) < 0.01)
        #expect(components[3] == 1.0)
    }

    /// Gray-scale Color(white:opacity:) with alpha.
    @Test func grayscaleColorWithAlpha() async throws {
        let color = Color(white: 0.3, opacity: 0.4)
        let components = color.components
        #expect(abs(components[0] - 0.3) < 0.01)
        #expect(abs(components[1] - 0.3) < 0.01)
        #expect(abs(components[2] - 0.3) < 0.01)
        #expect(abs(components[3] - 0.4) < 0.01)
    }

    /// Gray-scale white.
    @Test func grayscaleWhite() async throws {
        let color = Color(white: 1.0)
        let components = color.components
        #expect(abs(components[0] - 1.0) < 0.01)
        #expect(abs(components[1] - 1.0) < 0.01)
        #expect(abs(components[2] - 1.0) < 0.01)
        #expect(components[3] == 1.0)
    }

    /// Gray-scale black.
    @Test func grayscaleBlack() async throws {
        let color = Color(white: 0.0)
        let components = color.components
        #expect(components[0] == 0.0)
        #expect(components[1] == 0.0)
        #expect(components[2] == 0.0)
        #expect(components[3] == 1.0)
    }

#if canImport(AppKit)
    /// NSColor in sRGB color space bridged to Color.
    @Test func nsColorSRGB() async throws {
        let nsColor = NSColor(srgbRed: 0.1, green: 0.3, blue: 0.7, alpha: 0.9)
        let color = Color(nsColor: nsColor)
        let components = color.components
        #expect(abs(components[0] - 0.1) < 0.01)
        #expect(abs(components[1] - 0.3) < 0.01)
        #expect(abs(components[2] - 0.7) < 0.01)
        #expect(abs(components[3] - 0.9) < 0.01)
    }

    /// NSColor in calibrated RGB color space bridged to Color.
    @Test func nsColorCalibratedRGB() async throws {
        let nsColor = NSColor(calibratedRed: 0.2, green: 0.5, blue: 0.8, alpha: 0.6)
        let color = Color(nsColor: nsColor)
        let components = color.components
        #expect(abs(components[0] - 0.2) < 0.1)
        #expect(abs(components[1] - 0.5) < 0.1)
        #expect(abs(components[2] - 0.8) < 0.1)
        #expect(abs(components[3] - 0.6) < 0.01)
    }

    /// NSColor in device RGB color space bridged to Color.
    @Test func nsColorDeviceRGB() async throws {
        let nsColor = NSColor(deviceRed: 0.15, green: 0.45, blue: 0.75, alpha: 0.85)
        let color = Color(nsColor: nsColor)
        let components = color.components
        #expect(abs(components[0] - 0.15) < 0.01)
        #expect(abs(components[1] - 0.45) < 0.01)
        #expect(abs(components[2] - 0.75) < 0.01)
        #expect(abs(components[3] - 0.85) < 0.01)
    }

    /// NSColor in displayP3 color space bridged to Color, then converted to sRGB components.
    @Test func nsColorDisplayP3() async throws {
        let nsColor = NSColor(displayP3Red: 0.8, green: 0.2, blue: 0.4, alpha: 1.0)
        let color = Color(nsColor: nsColor)
        let components = color.components
        // P3 to sRGB conversion should preserve approximate values for mid-range
        #expect(abs(components[0] - 0.8) < 0.1)
        #expect(abs(components[1] - 0.2) < 0.2)
        #expect(abs(components[2] - 0.4) < 0.05)
        #expect(components[3] == 1.0)
    }

    /// NSColor generic gray color space bridged to Color.
    @Test func nsColorGenericGray() async throws {
        let nsColor = NSColor(genericGamma22White: 0.7, alpha: 0.5)
        let color = Color(nsColor: nsColor)
        let components = color.components
        #expect(abs(components[0] - 0.7) < 0.01)
        #expect(abs(components[1] - 0.7) < 0.01)
        #expect(abs(components[2] - 0.7) < 0.01)
        #expect(abs(components[3] - 0.5) < 0.01)
    }

    /// NSColor device gray color space bridged to Color.
    @Test func nsColorDeviceGray() async throws {
        let nsColor = NSColor(deviceWhite: 0.4, alpha: 0.8)
        let color = Color(nsColor: nsColor)
        let components = color.components
        #expect(abs(components[0] - 0.4) < 0.01)
        #expect(abs(components[1] - 0.4) < 0.01)
        #expect(abs(components[2] - 0.4) < 0.01)
        #expect(abs(components[3] - 0.8) < 0.01)
    }

    /// NSColor calibrated white bridged to Color.
    @Test func nsColorCalibratedWhite() async throws {
        let nsColor = NSColor(calibratedWhite: 0.6, alpha: 0.3)
        let color = Color(nsColor: nsColor)
        let components = color.components
        #expect(abs(components[0] - 0.6) < 0.1)
        #expect(abs(components[1] - 0.6) < 0.1)
        #expect(abs(components[2] - 0.6) < 0.1)
        #expect(abs(components[3] - 0.3) < 0.01)
    }

    /// NSColor named color (system color) bridged to Color.
    @Test func nsColorNamedSystemColor() async throws {
        let nsColor = NSColor.systemBlue
        let color = Color(nsColor: nsColor)
        let components = color.components
        // System colors should successfully convert to sRGB
        #expect(components[0] >= 0 && components[0] <= 1)
        #expect(components[1] >= 0 && components[1] <= 1)
        #expect(components[2] >= 0 && components[2] <= 1)
        #expect(components[3] >= 0 && components[3] <= 1)
    }

    /// NSColor created via hue/saturation/brightness.
    @Test func nsColorHSB() async throws {
        let nsColor = NSColor(hue: 0.6, saturation: 0.8, brightness: 0.9, alpha: 1.0)
        let color = Color(nsColor: nsColor)
        let components = color.components
        // HSB (0.6, 0.8, 0.9) ≈ blue-cyan, should have high blue channel
        #expect(components[2] >= 0.7)
        #expect(components[3] == 1.0)
    }

    /// NSColor created via cmyk.
    @Test func nsColorCMYK() async throws {
        let nsColor = NSColor(deviceCyan: 0.1, magenta: 0.2, yellow: 0.3, black: 0.4, alpha: 1.0)
        let color = Color(nsColor: nsColor)
        let components = color.components
        #expect(components[0] >= 0 && components[0] <= 1)
        #expect(components[1] >= 0 && components[1] <= 1)
        #expect(components[2] >= 0 && components[2] <= 1)
        #expect(components[3] == 1.0)
    }

    /// NSColor.clear should have alpha 0.
    @Test func nsColorClear() async throws {
        let nsColor = NSColor.clear
        let color = Color(nsColor: nsColor)
        let components = color.components
        #expect(components[3] == 0.0)
    }
#endif

#if canImport(UIKit)
    /// UIColor in sRGB bridged to Color.
    @Test func uiColorSRGB() async throws {
        let uiColor = UIColor(red: 0.2, green: 0.5, blue: 0.8, alpha: 0.7)
        let color = Color(uiColor: uiColor)
        let components = color.components
        #expect(abs(components[0] - 0.2) < 0.01)
        #expect(abs(components[1] - 0.5) < 0.01)
        #expect(abs(components[2] - 0.8) < 0.01)
        #expect(abs(components[3] - 0.7) < 0.01)
    }

    /// UIColor displayP3 bridged to Color.
    @Test func uiColorDisplayP3() async throws {
        let uiColor = UIColor(displayP3Red: 0.3, green: 0.6, blue: 0.9, alpha: 1.0)
        let color = Color(uiColor: uiColor)
        let components = color.components
        #expect(abs(components[0] - 0.3) < 0.1)
        #expect(abs(components[1] - 0.6) < 0.1)
        #expect(abs(components[2] - 0.9) < 0.1)
        #expect(components[3] == 1.0)
    }

    /// UIColor grayscale bridged to Color.
    @Test func uiColorGrayscale() async throws {
        let uiColor = UIColor(white: 0.5, alpha: 0.8)
        let color = Color(uiColor: uiColor)
        let components = color.components
        #expect(abs(components[0] - 0.5) < 0.01)
        #expect(abs(components[1] - 0.5) < 0.01)
        #expect(abs(components[2] - 0.5) < 0.01)
        #expect(abs(components[3] - 0.8) < 0.01)
    }

    /// UIColor hue/saturation/brightness bridged to Color.
    @Test func uiColorHSB() async throws {
        let uiColor = UIColor(hue: 0.0, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        let color = Color(uiColor: uiColor)
        let components = color.components
        // Hue 0, saturation 1, brightness 1 = pure red
        #expect(components[0] >= 0.9)
        #expect(components[3] == 1.0)
    }

    /// UIColor.clear should have alpha 0.
    @Test func uiColorClear() async throws {
        let uiColor = UIColor.clear
        let color = Color(uiColor: uiColor)
        let components = color.components
        #expect(components[3] == 0.0)
    }

    /// UIColor with cgColor from a custom colorspace.
    @Test func uiColorFromCGColorGrayColorSpace() async throws {
        guard let graySpace = CGColorSpace(name: CGColorSpace.genericGamma22Gray) else {
            return
        }
        let components: [CGFloat] = [0.7, 0.5]
        guard let cgColor = CGColor(colorSpace: graySpace, components: components) else {
            return
        }
        let uiColor = UIColor(cgColor: cgColor)
        let color = Color(uiColor: uiColor)
        let comps = color.components
        #expect(abs(comps[0] - 0.7) < 0.01)
        #expect(abs(comps[1] - 0.7) < 0.01)
        #expect(abs(comps[2] - 0.7) < 0.01)
        #expect(abs(comps[3] - 0.5) < 0.01)
    }
#endif

    /// Components roundtrip: Color -> components -> new Color -> components.
    @Test func componentsRoundtrip() async throws {
        let original = Color(.sRGB, red: 0.25, green: 0.5, blue: 0.75, opacity: 0.8)
        let comps1 = original.components
        let recreated = Color(.sRGB, components: comps1)
        let comps2 = recreated.components
        #expect(abs(comps1[0] - comps2[0]) < 0.001)
        #expect(abs(comps1[1] - comps2[1]) < 0.001)
        #expect(abs(comps1[2] - comps2[2]) < 0.001)
        #expect(abs(comps1[3] - comps2[3]) < 0.001)
    }

    /// Multiple roundtrips should be stable.
    @Test func componentsMultipleRoundtrips() async throws {
        var color = Color(.sRGB, red: 0.123, green: 0.456, blue: 0.789, opacity: 0.321)
        for _ in 0..<5 {
            let comps = color.components
            color = Color(.sRGB, components: comps)
        }
        let comps = color.components
        #expect(abs(comps[0] - 0.123) < 0.01)
        #expect(abs(comps[1] - 0.456) < 0.01)
        #expect(abs(comps[2] - 0.789) < 0.01)
        #expect(abs(comps[3] - 0.321) < 0.02)
    }

    /// Components should always be in 0...1 range.
    @Test func componentsInValidRange() async throws {
        let testColors: [Color] = [
            Color(.sRGB, red: 0, green: 0, blue: 0),
            Color(.sRGB, red: 1, green: 1, blue: 1),
            Color(.displayP3, red: 1, green: 0, blue: 0),
            Color(.displayP3, red: 0, green: 1, blue: 0),
            Color(.displayP3, red: 0, green: 0, blue: 1),
            Color(white: 0.3),
            Color(white: 0.0),
            Color(white: 1.0),
        ]
        for color in testColors {
            let components = color.components
            for i in 0..<4 {
                #expect(components[i] >= 0.0 && components[i] <= 1.0,
                        "Component \(i) = \(components[i]) out of range for color")
            }
        }
    }

    /// Components vector has exactly 4 elements.
    @Test func componentsIsSIMD4() async throws {
        let color = Color(.sRGB, red: 0.1, green: 0.2, blue: 0.3)
        let components = color.components
        // SIMD4 always has 4 scalars
        let array = [components[0], components[1], components[2], components[3]]
        #expect(array.count == 4)
    }

    // MARK: - All Colors

    @Test func allColorsCount() async throws {
        #expect(Color.allColors.count == 13)
    }

    @Test func allColorsContainsRed() async throws {
        #expect(Color.allColors.contains { $0 == Color.red })
    }

    @Test func allColorsContainsBlue() async throws {
        #expect(Color.allColors.contains { $0 == Color.blue })
    }

    // MARK: - AnimatableData

    @Test func animatableDataRoundtrip() async throws {
        var color = Color.red
        let data = color.animatableData
        color.animatableData = data
        for i in 0..<4 {
            #expect(abs(color.components[i] - Color.red.components[i]) < 0.0001)
        }
    }

    @Test func animatableDataGet() async throws {
        let color = Color.blue
        let data = color.animatableData
        #expect(data == color.components)
    }

    @Test func animatableDataSet() async throws {
        var color = Color.black
        color.animatableData = SIMD4<Double>(1, 0, 0, 1)
        #expect(color.components[0] == 1.0)
        #expect(color.components[1] == 0.0)
        #expect(color.components[2] == 0.0)
        #expect(color.components[3] == 1.0)
    }

    // MARK: - SIMD4 Components Init

    @Test func initFromComponents() async throws {
        let color = Color(.sRGB, components: SIMD4<Double>(0.5, 0.5, 0.5, 1.0))
        let comps = color.components
        #expect(abs(comps[0] - 0.5) < 0.01)
        #expect(abs(comps[1] - 0.5) < 0.01)
        #expect(abs(comps[2] - 0.5) < 0.01)
        #expect(abs(comps[3] - 1.0) < 0.01)
    }

    // MARK: - Codable

    @Test func codableRoundtrip() async throws {
        let original = Color.red
        let encoder = JSONEncoder()
        let data = try encoder.encode(original)
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(Color.self, from: data)
        let originalComps = original.components
        let decodedComps = decoded.components
        #expect(abs(originalComps[0] - decodedComps[0]) < 0.01)
        #expect(abs(originalComps[1] - decodedComps[1]) < 0.01)
        #expect(abs(originalComps[2] - decodedComps[2]) < 0.01)
        #expect(abs(originalComps[3] - decodedComps[3]) < 0.01)
    }

    @Test func codableWithAlpha() async throws {
        let original = Color(.sRGB, components: SIMD4<Double>(0.2, 0.4, 0.6, 0.5))
        let encoder = JSONEncoder()
        let data = try encoder.encode(original)
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(Color.self, from: data)
        let comps = decoded.components
        #expect(abs(comps[0] - 0.2) < 0.01)
        #expect(abs(comps[1] - 0.4) < 0.01)
        #expect(abs(comps[2] - 0.6) < 0.01)
        #expect(abs(comps[3] - 0.5) < 0.01)
    }

    @Test func decodeOpaqueColor() async throws {
        let json = #"{"red":1,"green":0,"blue":0}"#
        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        let color = try decoder.decode(Color.self, from: data)
        #expect(color.components[3] == 1.0)
    }

    // MARK: - Identifiable

    @Test func identifiable() async throws {
        let redID = Color.red.id
        let blueID = Color.blue.id
        #expect(redID != blueID)
    }

    @Test func sameColorSameID() async throws {
        let id1 = Color.red.id
        let id2 = Color.red.id
        #expect(id1 == id2)
    }

    // MARK: - SIMD4 AdditiveArithmetic

    @Test func simd4AdditiveArithmetic() async throws {
        var a = SIMD4<Double>(1, 2, 3, 4)
        let b = SIMD4<Double>(5, 6, 7, 8)
        a += b
        #expect(a == SIMD4<Double>(6, 8, 10, 12))
        a -= b
        #expect(a == SIMD4<Double>(1, 2, 3, 4))
    }

    @Test func simd4Scale() async throws {
        var value = SIMD4<Double>(1, 2, 3, 4)
        value.scale(by: 2)
        #expect(value == SIMD4<Double>(2, 4, 6, 8))
    }

    @Test func simd4MagnitudeSquared() async throws {
        let value = SIMD4<Double>(1, 2, 3, 4)
        #expect(value.magnitudeSquared == 30)
    }

    // MARK: - Light/Dark Init

    @Test func lightDarkInit() async throws {
        let color = Color {
            Color.red
        } dark: {
            Color.blue
        }
        let _ = color.components
    }

    // MARK: - listBackgroundColor (iOS only)

#if canImport(UIKit)
    @Test func listBackgroundColor() async throws {
        let _ = Color.listBackgroundColor
    }
#endif

}
