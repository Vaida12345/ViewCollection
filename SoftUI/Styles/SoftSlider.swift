//
//  SoftSlider.swift
//  ViewCollection
//
//  Created by Vaida on 2025-05-28.
//

import SwiftUI
import Essentials
import NativeImage


/// A slider with SoftUI style
///
/// ![Preview](SoftProgressStyle)
public struct SoftSlider<T>: View where T: BinaryFloatingPoint {
    
    @Binding var value: T
    
    /// The absolute offset
    private var offset: Double {
        initialOffset + (translation ?? 0)
    }
    
    /// The initial offset before the start of current gesture.
    @State private var initialOffset = 0.0
    
    /// The translation for current gesture, or `nil` for no gesture.
    @State private var translation: Double? = nil
    
    
    @State private var playsSensoryFeedback: Bool = false
    
    private let onDrag: (T) -> Void
    private let onEnd: (T) -> Void
    
    private let range: ClosedRange<T>
    
    private let scale: T
    
    
    private func gesture(size: CGSize) -> some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                self.translation = value.translation.width
                self.transactionUpdate(translation: translation, geometryWidth: size.width, isEnd: false)
            }
            .onEnded { value in
                self.initialOffset = clamp(self.offset, min: 0, max: size.width)
                self.translation = nil
                playsSensoryFeedback = false
                self.transactionUpdate(translation: 0, geometryWidth: size.width, isEnd: true)
            }
    }
    
    /// The normalized value within 0...1
    private var normalized: Double {
        get {
            Double((value - range.lowerBound) / scale)
        }
        nonmutating set {
            value = T(newValue) * scale + range.lowerBound
        }
    }
    
    private var backgroundHeight: Double {
        20
    }
    
    private var backgroundRadius: Double {
        self.backgroundHeight / 2
    }
    
    
    public var body: some View {
        GeometryReader { geometry in
            
            ZStack {
                SoftInnerShadow()
                    .frame(height: backgroundHeight)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    .softUIShape(.capsule)
                
                Capsule()
                    .fill(Color.soft.fill)
                    .frame(width: offset, height: backgroundHeight)
                    .position(x: offset / 2, y: geometry.size.height / 2)
                    .mask {
                        Capsule()
                            .frame(height: backgroundHeight)
                            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    }
            }
            .gesture(gesture(size: geometry.size))
            .onChange(of: value) { oldValue, newValue in
                if translation == nil {
                    updateFrom(value: newValue, width: geometry.size.width)
                }
            }
            .onChange(of: geometry.size.width) { _, newValue in
                updateFrom(value: self.value, width: newValue)
            }
            .onAppear {
                updateFrom(value: value, width: geometry.size.width)
            }
        }
        .frame(height: backgroundHeight)
#if !os(visionOS)
        .sensoryFeedback(.selection, trigger: normalized) { _, newValue in
            (newValue == 0 || newValue == 1) && translation != nil // ensure it is user initialized.
        }
        .sensoryFeedback(.selection, trigger: playsSensoryFeedback) { _, newValue in
            newValue
        }
#endif
        .frame(height: 20)
    }
    
    private func transactionUpdate(
        translation: Double?,
        geometryWidth: Double,
        isEnd: Bool
    ) {
        guard let translation else { return }
        let delta = translation / geometryWidth
        let raw = initialOffset / geometryWidth + delta
        if (self.normalized == 0 && raw < 0) || (self.normalized == 1 && raw > 1) {
            playsSensoryFeedback = true
        }
        let normalized = clamp(raw, min: 0, max: 1)
        onDrag(T(normalized) * scale + range.lowerBound)
        self.normalized = normalized
        
        if isEnd {
            onEnd(T(normalized) * scale + range.lowerBound)
        }
    }
    
    func updateFrom(value: T, width: Double) {
        let normal = Double((value - range.lowerBound) / scale)
        self.initialOffset = clamp(normal, min: 0, max: 1) * width
    }
    
    public init(
        value: Binding<T>,
        in range: ClosedRange<T> = 0...1,
        onDrag: @escaping (T) -> Void = { _ in },
        onEnd: @escaping (T) -> Void = { _ in }
    ) {
        self._value = value
        self.range = range
        self.scale = range.upperBound - range.lowerBound
        self.onDrag = onDrag
        self.onEnd = onEnd
    }
}


#Preview {
    @Previewable @State var value: Double = 0.5
    
    VStack {
        Spacer()
        
        SoftSlider(value: $value, in: 0...2)
            .padding(.vertical)
            .padding(.horizontal)
            .padding(.bottom, 20)
        
        Spacer()
    }
    .background(Color.soft.main)
}
