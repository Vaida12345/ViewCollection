//
//  􀴽 Circular.swift
//  ViewCollection
//
//  Created by Vaida on 2025-05-14.
//

import SwiftUI


/// Draws the **background** circle track once (no animatable data needed).
fileprivate struct CircularProgressTrack: Shape, Animatable {
    
    // Ratio of stroke width to the smallest dimension of the rect
    var thicknessRatio: Double
    var fraction: Double
    
    var animatableData: AnimatablePair<Double, Double> {
        get {
            AnimatablePair(thicknessRatio, fraction)
        }
        set {
            self.thicknessRatio = newValue.first
            self.fraction = newValue.second
        }
    }
    
    fileprivate func path(in rect: CGRect) -> Path {
        let minSide = min(rect.width, rect.height)
        let lineWidth = minSide * thicknessRatio
        let radius = (minSide - lineWidth) / 2
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        // Build a full 360° circle
        var circle = Path()
        circle.addArc(center: center,
                      radius: radius,
                      startAngle: .degrees(-90),
                      endAngle: .degrees(-90 + 360 * fraction),
                      clockwise: false)
        
        // Return a *stroked* version of that circle
        return circle.strokedPath(StrokeStyle(lineWidth: lineWidth, lineCap: .round))
    }
}

/// Draws the **progress** arc from –90° up to –90° + 360°·fraction.
fileprivate struct CircularProgressArc: Shape, Animatable {
    // fraction ∈ [0…1]
    var fraction: Double
    
    // Make this shape animatable
    fileprivate var animatableData: Double {
        get { fraction }
        set { fraction = newValue }
    }
    
    // Same stroke‐thickness logic as the track
    private let thicknessRatio: CGFloat = 0.10
    
    fileprivate func path(in rect: CGRect) -> Path {
        let minSide = min(rect.width, rect.height)
        let lineWidth = minSide * thicknessRatio
        let radius = (minSide - lineWidth) / 2
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        var arc = Path()
        arc.addArc(center: center,
                   radius: radius,
                   startAngle: .degrees(-90),
                   endAngle: .degrees(-90 + 360 * fraction),
                   clockwise: false)
        
        return arc.strokedPath(
            StrokeStyle(lineWidth: lineWidth, lineCap: .round)
        )
    }
}

/// A ProgressViewStyle that overlays the track + the animatable arc.
public struct CircularProgressViewStyle: ProgressViewStyle {
    private let color: Color
    private let checkmarkOnCompletion: Bool
    @State private var showProgressTrack = false
    
    public init(
        color: Color,
        checkmarkOnCompletion: Bool
    ) {
        self.color = color
        self.checkmarkOnCompletion = checkmarkOnCompletion
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        ZStack {
            // 1) The track (static)
            CircularProgressTrack(thicknessRatio: showProgressTrack ? 0.1 : 0, fraction: showProgressTrack ? 1 : 0)
                .foregroundColor(color.mix(with: .secondary, by: 0.8).opacity(0.3))
                .rotationEffect(.degrees(showProgressTrack ? 0 : -90))
                .onAppear {
                    withAnimation(.default.delay(0.2)) {
                        showProgressTrack = true
                    }
                }
            
            // 2) The animated arc
            if let fraction = configuration.fractionCompleted {
                CircularProgressArc(fraction: fraction)
                    .foregroundColor(color)
            }
            
            if configuration.fractionCompleted == 1 && checkmarkOnCompletion {
                CheckMarkView(strokeWidthFraction: 1 / 8)
                    .foregroundStyle(color)
                    .padding()
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .help("\(configuration.fractionCompleted ?? 0, format: .percent.precision(.fractionLength(2)))")
        .animation(.linear, value: configuration.fractionCompleted)
    }
}


extension ProgressViewStyle where Self == CircularProgressViewStyle {
    
    /// Creates a circular style
    ///
    /// This style draws the arc when the `fractionCompleted` is none `nil`.
    ///
    /// ![Preview](CircularProgressTrack)
    ///
    /// - Parameters:
    ///   - color: The primary color.
    ///   - checkmarkOnCompletion: Whether to show a check mark when `fractionCompleted` is 100%.
    public static func circular(
        color: Color = .accentColor,
        checkmarkOnCompletion: Bool = false
    ) -> CircularProgressViewStyle {
        CircularProgressViewStyle(
            color: color,
            checkmarkOnCompletion: checkmarkOnCompletion
        )
    }
    
}


struct TestDriverView: View {
    @State var value = 0.0
    @State var isShown = false
    
    var body: some View {
        VStack {
            if isShown {
                ProgressView(value: Double(Int(value)), total: 10) // discrete to test animation
                    .progressViewStyle(.circular(checkmarkOnCompletion: true))
                    .frame(width: 160, height: 160)
                    .padding()
                    .animation(.linear, value: value)
            } else {
                Button("Show") {
                    withAnimation {
                        isShown = true
                    }
                }
                .frame(width: 200, height: 200)
            }
            
            Slider(value: $value.animation(), in: 0...10)
                .frame(width: 200)
                .padding()
        }
    }
}


#Preview {
    TestDriverView()
}

