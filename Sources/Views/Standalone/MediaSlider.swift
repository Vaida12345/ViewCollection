//
//  MediaSlider.swift
//  ViewCollection
//
//  Created by Vaida on 12/2/24.
//


import SwiftUI
import Essentials


/// A slider style that mimics iOS media playback.
public struct MediaSlider<T>: View where T: BinaryFloatingPoint {
    
    @Binding var value: T
    
    @State private var transactionWidth: Double? = nil
    
    @State private var progressOnStart: Double? = nil
    
    @State private var playsSensoryFeedback = false
    
    let onDrag: (T) -> Void
    
    let range: ClosedRange<T>
    
    let scale: T
    
    var gesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                transactionWidth = value.translation.width
                if progressOnStart == nil {
                    progressOnStart = normalized
                    withAnimation {
                        backgroundHeight = 15
                    }
                }
            }
            .onEnded { _ in
                // finalize
                transactionWidth = nil
                progressOnStart = nil
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
    
    @Environment(\.colorScheme) private var colorScheme
    
    
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
                    .fill(.separator)
                    .frame(height: backgroundHeight)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    .shadow(radius: 5)
                
                let progressWidth = normalized * geometry.size.width
                
                Rectangle()
                    .fill(.white)
                    .frame(width: progressWidth, height: backgroundHeight)
                    .position(x: progressWidth / 2, y: geometry.size.height / 2)
                    .mask {
                        RoundedRectangle(cornerRadius: backgroundRadius)
                            .frame(height: backgroundHeight)
                            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    }
            }
            .offset(x: reshapeOffset)
            .scaleEffect(reshape)
            .onChange(of: transactionWidth) { _, newValue in
                transactionUpdate(transactionWidth: newValue, geometryWidth: geometry.size.width)
            }
            .gesture(gesture)
        }
        .frame(height: backgroundHeight)
#if !os(visionOS)
        .sensoryFeedback(.selection, trigger: normalized) { _, newValue in
            newValue == 0 || newValue == 1
        }
        .sensoryFeedback(.selection, trigger: playsSensoryFeedback) { _, newValue in
            newValue
        }
#endif
    }
    
    private func transactionUpdate(transactionWidth: Double?, geometryWidth: Double) {
        guard let transactionWidth, let progressOnStart else { return }
        let delta = transactionWidth / geometryWidth
        let raw = progressOnStart + delta
        if (self.normalized == 0 && raw < 0) || (self.normalized == 1 && raw > 1) {
            playsSensoryFeedback = true
        }
        self.normalized = clamp(raw, min: 0, max: 1)
        onDrag(value)
        
        // handle overflow
        if raw < 0 || raw > 1 {
            let normal = abs(tanh(raw > 1 ? raw - 1 : raw))
            self.reshape = CGSize(width: 1 + normal * 0.1, height: 1)
            self.backgroundHeight = clamp(15 - normal * 15, min: 2)
        }
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
        .frame(width: 200, height: 10)
        .padding(.vertical)
}
