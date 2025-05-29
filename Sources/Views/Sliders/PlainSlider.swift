//
//  PlainSlider.swift
//  PianoVisualizer
//
//  Created by Vaida on 11/26/24.
//

import SwiftUI
import Essentials


/// A plain slider designed for macOS.
///
/// ![Preview](PlainSlider)
@available(macOS 14.0, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public struct PlainSlider<T>: View where T: BinaryFloatingPoint {
    
    @Binding private var value: T
    
    @State private var location: Double = 0
    
    private let onDrag: (T) -> Void
    
    private let range: ClosedRange<T>
    
    private let scale: T
    
    private var radius: Double {
        3
    }
    
    private var diameter: Double {
        radius * 2
    }
    
    private var gesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                location = value.location.x
            }
    }
    
    private var normalized: T {
        get {
            (value - range.lowerBound) / scale
        }
        nonmutating set {
            value = newValue * scale + range.lowerBound
        }
    }
    
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.sliderProgressBarColor)
                    .frame(height: radius)
                    .padding(.vertical)
                    .frame(height: diameter * 3)
                    .contentShape(Rectangle()) // larger for easier hitting
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    .onTapGesture { point in
                        location = point.x
                    }
                
                Capsule()
                    .fill(Color.handleColor)
                    .frame(width: diameter, height: diameter * 3)
                    .shadow(radius: 1)
                    .position(x: Double(normalized) * (geometry.size.width - diameter) + radius, y: geometry.size.height / 2)
                    .gesture(gesture)
            }
            .onChange(of: location) { oldValue, newValue in
                normalized = T(clamp((newValue - radius) / (geometry.size.width - diameter), min: 0, max: 1))
                onDrag(value)
            }
        }
        .frame(height: diameter * 4)
    }
    
    public init(value: Binding<T>, in range: ClosedRange<T>, onDrag: @escaping (T) -> Void = { _ in }) {
        self._value = value
        self.range = range
        self.scale = range.upperBound - range.lowerBound
        self.onDrag = onDrag
    }
}


private extension Color {
    
    static var sliderProgressBarColor: Color {
        Color.secondary
    }
    
    static var handleColor: Color {
        Color(white: 192 / 255)
    }
    
}


#if os(macOS)
#Preview {
    @Previewable @State var value: Double = 0
    
    PlainSlider(value: $value, in: 0...2)
        .frame(width: 200, height: 10)
        .padding(.vertical)
        .padding()
}
#endif
