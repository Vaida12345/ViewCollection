//
//  ColorPalette.swift
//  The ViewCollection Module
//
//  Created by Vaida on 6/19/23.
//  Copyright © 2019 - 2024 Vaida. All rights reserved.
//

import SwiftUI
import NativeImage


/// The palette as a color picker.
///
/// ```swift
/// ColorPaletteView(color: $color, set: Color.allColors)
/// ```
///
/// - Note: The control sizes can be adjusted using the `imageScale` environment value.
///
/// ![Example View](colorPaletteView)
public struct ColorPaletteView: View {
    
    @Binding private var color: Color
    
    // there only exists a custom color when there is no match in `colorSet`.
    @State private var customColor: Color? = nil
    
    @Environment(\.imageScale) private var imageScale
    
    private let colorSet: [Color]
    
    private let shownCustomColor: Bool
    
    private var frame: Frame {
        Frame(scale: self.imageScale)
    }
    
    
    public var body: some View {
        FilledVGrid(spacing: .none) {
            ForEach(colorSet, id: \.self) { color in
                _color(color)
            }
            
#if !os(tvOS) && !os(watchOS)
            if shownCustomColor {
                colorPicker
            }
#endif
        }
    }
    
    @ViewBuilder
    private func _color(_ color: Color) -> some View {
        Button {
            withAnimation {
                self.color = color
                self.customColor = nil
            }
        } label: {
            ZStack {
                let showBorder = self.color.isEqual(to: color) && customColor == nil
                
                Circle()
                    .stroke(color, lineWidth: frame.strokeWidth)
                    .frame(width: showBorder ? frame.extendedDiameter : frame.innerDiameter + frame.strokeWidth / 2)
                    .animation(.spring(), value: showBorder)
                
                Circle()
                    .fill(color)
                    .frame(width: frame.innerDiameter)
            }
        }
        .buttonStyle(.plain)
        .frame(width: frame.outerDiameter, height: frame.outerDiameter)
    }
    
#if !os(tvOS) && !os(watchOS)
    @ViewBuilder
    private var colorPicker: some View {
        Group {
            ZStack {
                let showBorder = customColor != nil
                
                Circle()
                    .stroke(customColor ?? .black, lineWidth: frame.strokeWidth)
                    .frame(width: showBorder ? frame.extendedDiameter : frame.innerDiameter - frame.strokeWidth)
                    .animation(.spring(), value: showBorder)
                
                Circle()
                    .fill(AngularGradient(colors: [.red, .blue, .green, .yellow, .red], center: .center, startAngle: .zero, endAngle: .degrees(360)))
                    .frame(width: frame.innerDiameter + (showBorder ? 0 : frame.strokeWidth), height: frame.innerDiameter + (showBorder ? 0 : frame.strokeWidth))
                
                ColorPicker(selection: Binding<Color> {
                    customColor ?? .black
                } set: {
                    customColor = $0
                    self.color = $0
                }) { }
                    .frame(width: frame.innerDiameter + (showBorder ? 0 : frame.strokeWidth), height: frame.innerDiameter + (showBorder ? 0 : frame.strokeWidth))
                    .opacity(0.1)
                    .clipShape(Circle())
            }
        }
        .frame(width: frame.outerDiameter, height: frame.outerDiameter)
        .onChange(of: color) { _, color in
            guard customColor == nil else { return }
            if !colorSet.contains(where: { color.isEqual(to: $0) }) {
                self.customColor = color
            }
        }
    }
#endif
    
    private init(color: Binding<Color>, set colorSet: [Color], shownCustomColor: Bool) {
        self._color = color
        self.colorSet = colorSet
        self.shownCustomColor = shownCustomColor
        
        if !colorSet.contains(where: { color.wrappedValue.isEqual(to: $0) }) {
            self._customColor = State<Color?>(initialValue: color.wrappedValue)
        }
    }
    
    /// Creates a color palette.
    ///
    /// - Parameters:
    ///   - color: The selection of color.
    ///   - colorSet: The set of color to choose from.
    public init(color: Binding<Color>, set colorSet: [Color] = [.red, .orange, .yellow, .green, .mint, .cyan, .blue, .purple, .pink]) {
        self.init(color: color, set: colorSet, shownCustomColor: false)
    }
    
    /// Determines whether show the custom color picker in the palette.
    @available(*, deprecated, renamed: "showCustomColorPicker")
    public func showCustomColor(_ bool: Bool) -> ColorPaletteView {
        self.showCustomColorPicker(bool)
    }
    
    /// Determines whether show the custom color picker in the palette.
    public func showCustomColorPicker(_ bool: Bool = true) -> ColorPaletteView {
        ColorPaletteView(color: $color, set: colorSet, shownCustomColor: bool)
    }
    
    
    struct Frame {
        
        /// The width for the containers.
        let outerDiameter: Double
        
        /// The diameter of the always present circle.
        let innerDiameter: Double
        
        /// Diameter of the ring when selected.
        let extendedDiameter: Double
        
        let strokeWidth: Double
        
        
        init(scale: Image.Scale) {
            switch scale {
            case .small:
                self.outerDiameter = 25
                self.innerDiameter = 15
                self.extendedDiameter = 20.83
                self.strokeWidth = 1.67
            case .medium:
                self.outerDiameter = 30
                self.innerDiameter = 18
                self.extendedDiameter = 25
                self.strokeWidth = 2
            case .large:
                self.outerDiameter = 40
                self.innerDiameter = 24
                self.extendedDiameter = 33.33
                self.strokeWidth = 2.67
            @unknown default:
                self.outerDiameter = 30
                self.innerDiameter = 18
                self.extendedDiameter = 25
                self.strokeWidth = 2
            }
        }
        
    }
    
}


private extension Color {
    
    func isEqual(to color: Color) -> Bool {
        let lhs =  self.animatableData
        let rhs = color.animatableData
        for i in 0..<lhs.count {
            guard abs(lhs[i] - rhs[i]) <= 0.1 else { return false }
        }
        
        return true
    }
    
}

#Preview("Small") {
    @Previewable @State var color: Color = .pink
    
    ColorPaletteView(color: $color)
        .showCustomColorPicker(true)
        .imageScale(.small)
}

#Preview("Medium") {
    @Previewable @State var color: Color = .pink
    
    ColorPaletteView(color: $color)
        .showCustomColorPicker(true)
        .imageScale(.medium)
}

#Preview("Large") {
    @Previewable @State var color: Color = .pink
    
    ColorPaletteView(color: $color)
        .showCustomColorPicker(true)
        .imageScale(.large)
}
