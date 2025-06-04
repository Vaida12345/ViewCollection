//
//  Layered3dEffect.swift
//  VocalRemover
//
//  Created by Vaida on 2025-05-29.
//

import SwiftUI


/// A view that creates a `layer.3d` effect.
///
/// ```swift
/// Layered3dEffectView {
///     Image(systemName: "square.text.square.fill")
/// }
/// ```
///
/// ![Preview](Layered3dEffectView)
public struct Layered3dEffectView<Content: View>: View {
    
    let content: () -> Content
    let background: [Color]?
    
    
    public var body: some View {
        ZStack {
            ForEach(1..<4) { i in
                Image(.halfSquareDashed)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .visualEffect { content, geometry in
                        content
                            .layered3dEffect(geometry: geometry)
                            .offset(x: geometry.size.width * 0.23 * CGFloat(i), y: -geometry.size.height * 0.13 * CGFloat(i))
                            .offset(x: -geometry.size.width * 0.34, y: geometry.size.width * 0.2)
                    }
                    .foregroundStyle(background?.element(at: i - 1).map({ AnyShapeStyle($0) }) ?? AnyShapeStyle(.secondary))
            }
            
            content()
                .aspectRatio(contentMode: .fit)
                .visualEffect { content, geometry in
                    content
                        .layered3dEffect(geometry: geometry)
                        .offset(x: -geometry.size.width * 0.34, y: geometry.size.width * 0.2)
                }
        }
        .visualEffect { content, geometry in
            content.scaleEffect(0.69)
        }
    }
    
    public func backgroundStyle(_ first: Color, _ second: Color, _ third: Color) -> Layered3dEffectView {
        Layered3dEffectView(content: self.content, background: [first, second, third])
    }
    
    
    internal init(content: @escaping () -> Content, background: [Color]? = nil) {
        self.content = content
        self.background = background
    }
    
    public init(image: @escaping () -> Image) where Content == Image {
        self.content = {
            image().resizable()
        }
        self.background = nil
    }
    
    public init(content: @escaping () -> Content) {
        self.content = content
        self.background = nil
    }
    
}


extension VisualEffect {
    
    public func layered3dEffect(geometry: GeometryProxy) -> some VisualEffect {
        self
            .scaleEffect(x: 0.65, y: 0.77)
            .offset(y: -geometry.size.height * 0.29)
            .distortionEffect(
                ShaderLibrary.bundle(.module).layers_3d(.float2(CGPoint(x: geometry.size.width, y: geometry.size.height))),
                maxSampleOffset: CGSize.square(geometry.size.width / 2)
            )
    }
    
}

#Preview {
    Layered3dEffectView {
        Image(systemName: "square.text.square.fill")
    }
    .backgroundStyle(.blue, .yellow, .brown)
    .padding(.horizontal, 100)
    .offset(y: 100)
    .foregroundStyle(.blue)
}

