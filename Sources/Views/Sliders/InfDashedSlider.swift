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
public struct InfDashedSlider<T>: View where T: BinaryFloatingPoint {
    
    @Binding var value: T
    
    @State private var valueBase = 0.0
    
    let dividersCount = 35
    
    @State private var offset = 0.0
    
    @State private var translate = 0.0
    
    @State private var addition = 0.0
    
    @State private var isInitial = false
    
    @State private var isDragging = false
    
    var gesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                self.offset = value.translation.width + addition
                if !self.isDragging {
                    self.isInitial = true
                    self.isDragging = true
                }
            }
            .onEnded { value in
                self.addition = self.translate
                self.isDragging = false
            }
    }
    
    
    public var body: some View {
        GeometryReader { geometry in
            let scaleFactor = 8.0
            let dividerMaxGap = tanh(1 / scaleFactor) * geometry.size.width / 2
            
            let _normalize: (_ i: Int) -> Double = { i in
                let position = Double(i - dividersCount / 2) / scaleFactor
                return tanh(position + translate / dividerMaxGap / scaleFactor) * geometry.size.width / 2 + geometry.size.width / 2
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
                        .position(x: normal, y: geometry.size.height / 2)
                        .opacity(opacity)
                }
            }
            .environment(\.colorScheme, .light)
            .onChange(of: offset) { oldValue, newValue in
                let oldTranslate = translate
                translate = newValue.truncatingRemainder(dividingBy: dividerMaxGap)
                
                guard !isInitial else {
                    self.isInitial = false
                    return
                }
                // determine left right
                let isIncreasing = newValue < oldValue
                
                let float = -(translate / dividerMaxGap)
                
                if isIncreasing {
                    if oldTranslate > translate {
                        // increasing, but not reach top
                    } else {
                        valueBase += 1
                    }
                } else {
                    if oldTranslate < translate {
                        
                    } else {
                        valueBase -= 1
                    }
                }
                
                self.value = T(float + valueBase)
            }
        }
        .contentShape(Rectangle())
        .gesture(gesture)
        .sensoryFeedback(.selection, trigger: Int(value))
    }
    
    public init(value: Binding<T>) {
        self._value = value
    }
}


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
