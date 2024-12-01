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
///
/// ```swift
/// ColorPaletteView(color: $color, set: Color.allColors)
/// ```
///
/// ![Example View](colorPaletteView)
public struct ColorPaletteView: View {
    
    @Binding private var color: Color
    
    // there only exists a custom color when there is no match in `colorSet`.
    @State private var customColor: Color? = nil
    
    private let colorSet: [Color]
    
    private let shownCustomColor: Bool
    
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
                    .stroke(color, lineWidth: 2)
                    .frame(width: showBorder ? 25 : 19, height: showBorder ? 25 : 19)
                    .animation(.spring(), value: showBorder)
                
                Circle()
                    .fill(color)
                    .frame(width: 18, height: 18)
            }
        }
        .buttonStyle(.plain)
        .frame(width: 30, height: 30)
    }
    
#if !os(tvOS) && !os(watchOS)
    @ViewBuilder
    private var colorPicker: some View {
        Group {
            ZStack {
                let showBorder = customColor != nil
                
                Circle()
                    .stroke(customColor ?? .black, lineWidth: 2)
                    .frame(width: showBorder ? 25 : 16, height: showBorder ? 25 : 16)
                    .animation(.spring(), value: showBorder)
                
                Circle()
                    .fill(AngularGradient(colors: [.red, .blue, .green, .yellow], center: .center, startAngle: .zero, endAngle: .degrees(360)))
                    .frame(width: 20, height: 20)
                
                ColorPicker(selection: Binding<Color> {
                    customColor ?? .black
                } set: {
                    customColor = $0
                    self.color = $0
                }) { }
                    .frame(width: 20, height: 20)
                    .opacity(0.1)
                    .clipShape(Circle())
            }
        }
        .frame(width: 30, height: 30)
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
    public func showCustomColor(_ bool: Bool) -> ColorPaletteView {
        ColorPaletteView(color: $color, set: colorSet, shownCustomColor: bool)
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


#if DEBUG && os(macOS)
struct ColorPalettePreview: PreviewProvider {
    static var previews: some View {
        ColorPaletteView(color: .constant(.blue))
    }
}
#endif
