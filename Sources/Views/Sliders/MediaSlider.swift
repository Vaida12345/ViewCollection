//
//  MediaSlider.swift
//  ViewCollection
//
//  Created by Vaida on 12/2/24.
//

import SwiftUI
import Essentials
import NativeImage


/// A slider style that mimics iOS media playback.
public struct MediaSlider<T>: View where T: BinaryFloatingPoint {
    
    @Binding var value: T
    
    /// The absolute offset
    var offset: Double {
        initialOffset + (translation ?? 0)
    }
    
    /// The initial offset before the start of current gesture.
    @State private var initialOffset = 0.0
    
    /// The translation for current gesture, or `nil` for no gesture.
    @State private var translation: Double? = nil
    
    
    @State private var playsSensoryFeedback: Bool = false
    
    let onDrag: (T) -> Void
    
    let range: ClosedRange<T>
    
    let scale: T
    
    
    func gesture(size: CGSize) -> some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                if translation == nil {
                    withAnimation {
                        backgroundHeight = 15
                    }
                }
                
                self.translation = value.translation.width
                self.transactionUpdate(translation: translation, geometryWidth: size.width)
            }
            .onEnded { value in
                self.initialOffset = clamp(self.offset, min: 0, max: size.width)
                self.translation = nil
                playsSensoryFeedback = false
                
                withAnimation {
                    backgroundHeight = 10
                    reshape = CGSize(width: 1, height: 1)
                }
            }
    }
    
    /// The normalized value within 0...1
    var normalized: Double {
        get {
            Double((value - range.lowerBound) / scale)
        }
        nonmutating set {
            value = T(newValue) * scale + range.lowerBound
        }
    }
    
    @State private var backgroundHeight: Double = 10
    
    var backgroundRadius: Double {
        self.backgroundHeight / 2
    }
    
    @State private var reshape = CGSize(width: 1, height: 1)
    
    
    public var body: some View {
        GeometryReader { geometry in
            var reshapeOffset: Double {
                let newWidth = geometry.size.width * reshape.width
                if normalized == 0 {
                    return -(newWidth - geometry.size.width)
                } else {
                    return (newWidth - geometry.size.width)
                }
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: backgroundRadius)
                    .fill(.ultraThinMaterial)
                    .frame(height: backgroundHeight)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    .shadow(radius: 10)
                
                Rectangle()
                    .fill(.white)
                    .frame(width: clamp(offset, min: 0, max: geometry.size.width), height: backgroundHeight)
                    .position(x: offset / 2, y: geometry.size.height / 2)
                    .mask {
                        RoundedRectangle(cornerRadius: backgroundRadius)
                            .frame(height: backgroundHeight)
                            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    }
            }
            .offset(x: reshapeOffset)
            .scaleEffect(reshape)
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
        .environment(\.colorScheme, .light)
#if !os(visionOS)
        .sensoryFeedback(.selection, trigger: normalized) { _, newValue in
            (newValue == 0 || newValue == 1) && translation != nil // ensure it is user initialized.
        }
        .sensoryFeedback(.selection, trigger: playsSensoryFeedback) { _, newValue in
            newValue
        }
#endif
        .frame(height: 15)
    }
    
    private func transactionUpdate(translation: Double?, geometryWidth: Double) {
        guard let translation else { return }
        let delta = translation / geometryWidth
        let raw = initialOffset / geometryWidth + delta
        if (self.normalized == 0 && raw < 0) || (self.normalized == 1 && raw > 1) {
            playsSensoryFeedback = true
        }
        self.normalized = clamp(raw, min: 0, max: 1)
        onDrag(value)
        
        // handle overflow
        if raw < 0 || raw > 1 {
            let normal = abs(tanh(raw > 1 ? raw - 1 : raw))
            self.reshape = CGSize(width: 1 + normal * 0.1, height: 1)
            self.backgroundHeight = clamp(15 - normal * 15, min: 4)
        }
    }
    
    func updateFrom(value: T, width: Double) {
        let normal = Double((value - range.lowerBound) / scale)
        self.initialOffset = clamp(normal, min: 0, max: 1) * width
    }
    
    public init(value: Binding<T>, in range: ClosedRange<T> = 0...1, onDrag: @escaping (T) -> Void = { _ in }) {
        self._value = value
        self.range = range
        self.scale = range.upperBound - range.lowerBound
        self.onDrag = onDrag
    }
}


#Preview {
    @Previewable @State var value: Double = 0
    
    MediaSlider(value: $value, in: 0...2)
        .frame(width: 200, height: 15)
        .padding(.vertical)
}
