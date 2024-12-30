//
//  InfDashedSlider.swift
//  ViewCollection
//
//  Created by Vaida on 12/17/24.
//

import SwiftUI


/// A Inf Dashed Slider.
///
/// - term `value`: The length of dividers is assigned value `1`.
@available(iOS 17, *)
@available(visionOS 1, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct InfDashedSlider<T>: View where T: BinaryFloatingPoint {
    
    @Binding var value: T
    
    /// The absolute offset
    var offset: Double {
        initialOffset + (translation ?? 0)
    }
    
    /// The initial offset before the start of current gesture.
    @State private var initialOffset = 0.0
    
    /// The translation for current gesture, or `nil` for no gesture.
    @State private var translation: Double? = nil
    
    
    func minorOffset(dividerMaxGap: Double) -> Double {
        offset.truncatingRemainder(dividingBy: dividerMaxGap)
    }
    
    func gesture(dividerMaxGap: Double) -> some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                self.translation = value.translation.width
                
                self.value = -T(self.offset / dividerMaxGap)
            }
            .onEnded { value in
                self.initialOffset = self.offset
                self.translation = nil
            }
    }
    
    
    let dividersCount = 35
    
    let scaleFactor = 8.0
    
    
    public var body: some View {
        GeometryReader { geometry in
            let dividerMaxGap = tanh(1 / scaleFactor) * geometry.size.width / 2
            
            let _normalize: (_ i: Int) -> Double = { i in
                let position = Double(i - dividersCount / 2) / scaleFactor
                return tanh(position + minorOffset(dividerMaxGap: dividerMaxGap) / dividerMaxGap / scaleFactor) * geometry.size.width / 2 + geometry.size.width / 2
            }
            
            Group {
                ForEach(0..<dividersCount, id: \.self) { i in
                    let normal = _normalize(i)
                    /// Distance to nearest one to the center
                    let distanceToCenter = abs(normal - _normalize(i < dividersCount / 2 ? i+1 : i-1))
                    let opacity = distanceToCenter / dividerMaxGap
                    
                    Capsule()
                        .frame(width: 4)
                        .foregroundStyle(.regularMaterial)
                        .position(x: normal, y: 10)
                        .opacity(opacity)
                }
            }
            .environment(\.colorScheme, .light)
            .frame(height: 20)
            .padding(.vertical)
            .frame(height: 40)
            .contentShape(Rectangle())
            .gesture(gesture(dividerMaxGap: dividerMaxGap))
            .sensoryFeedback(.selection, trigger: Int(value))
            .onChange(of: value) { oldValue, newValue in
                if translation == nil {
                    updateFrom(value: Double(newValue), dividerMaxGap: dividerMaxGap)
                }
            }
            .onAppear {
                updateFrom(value: Double(value), dividerMaxGap: dividerMaxGap)
            }
        }
        .frame(height: 40)
    }
    
    public init(value: Binding<T>) {
        self._value = value
    }
    
    func updateFrom(value: Double, dividerMaxGap: Double) {
        initialOffset = -value * dividerMaxGap
    }
}


#if os(iOS) || os(visionOS)
#Preview(traits: .landscapeLeft) {
    @Previewable @State var value = 0.0
    
    VStack {
        Spacer()
        
        InfDashedSlider(value: $value)
            .ignoresSafeArea()
            .preferredColorScheme(.dark)
            .frame(height: 20)
            .padding(.bottom)
    }
}
#endif
