//
//  CheckMarkView.swift
//  ViewCollection
//
//  Created by Vaida on 9/12/24.
//

import SwiftUI


/// A check mark view.
///
/// This view always comes with an animation on appear.
///
/// This view always keeps an aspect ratio of one.
///
/// This view changes the stroke line width automatically.
///
/// ```swift
/// CheckMarkView()
///     .foregroundStyle(.blue)
///     .frame(width: 200)
/// ```
///
/// ![Example](CheckMarkView)
public struct CheckMarkView: View {
    
    @State private var isShown = false
    
    @Environment(\.isPresented) private var isPresented
    
    
    public var body: some View {
        GeometryReader { proxy in
            let size = min(proxy.size.width, proxy.size.height)
            
            Path { path in
                let startPoint = CGPoint(x: size * 0.2, y: size * 0.5)
                let midPoint = CGPoint(x: size * 0.4, y: size * 0.7)
                let endPoint = CGPoint(x: size * 0.8, y: size * 0.3)
                
                path.move(to: startPoint)
                path.addLine(to: midPoint)
                path.addLine(to: endPoint)
            }
            .trim(from: 0, to: isShown ? 1 : 0)
            .stroke(
                style: StrokeStyle(
                    lineWidth: size / 10,
                    lineCap: .round,
                    lineJoin: .round
                )
            )
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.5)) {
                isShown = true
            }
        }
        .allowsHitTesting(false) // allow gesture to pass through to the view beneath
    }
    
    
    public init() {
        
    }
    
}


private struct PreviewDriver: View {
    @State var isShown = false
    
    var body: some View {
        
        Group {
            if isShown {
                CheckMarkView()
            } else {
                Rectangle()
                    .fill(.clear)
                    .onAppear {
                        withAnimation(.default.delay(0)) {
                            isShown = true
                        }
                    }
            }
        }
        .frame(width: 200, height: 200)
    }
}

#Preview {
    PreviewDriver()
}
