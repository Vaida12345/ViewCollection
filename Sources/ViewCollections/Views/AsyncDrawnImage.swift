//
//  AsyncDrawnImage.swift
//  
//
//  Created by Vaida on 6/19/24.
//

import SwiftUI
import Stratum


/// An image that is drawn without blocking the main thread.
///
/// This view is best used in cases where the size of the image is known.
public struct AsyncDrawnImage: View {
    
    private let frame: CGSize
    
    private let contentMode: ContentMode
    
    private let source: Source
    
    private let cornerRadius: CGFloat
    
    @Environment(\.displayScale) private var displayScale
    
    
    nonisolated private func contextDraw() async -> CGImage? {
        let contextSize = await CGSize(width: frame.width * displayScale, height: frame.height * displayScale)
        let source: CGImage?
        switch self.source {
        case .image(let cgImage):
            source = cgImage
        case .generator(let generator):
            source = await generator()
        }
        guard let source else { return nil }
        
        let imageSize = source.size.aspectRatio(contentMode, in: contextSize)
        
        let context = CGContext.createContext(size: contextSize, bitsPerComponent: source.bitsPerComponent, space: CGColorSpaceCreateDeviceRGB(), withAlpha: true)
        
        context.interpolationQuality = .high
        
        let path = createRoundedRectPath(for: CGRect(center: contextSize.center, size: imageSize), radius: cornerRadius)
        
        context.addPath(path)
        context.clip()
        
        context.draw(source, in: CGRect(center: contextSize.center, size: imageSize))
        
        return context.makeImage()
    }
    
    public var body: some View {
        AsyncView(generator: contextDraw) { (image: CGImage?) in
            if let image {
#if canImport(AppKit)
                Image(nsImage: NSImage(cgImage: image, size: frame))
#elseif canImport(UIKit)
                Image(uiImage: UIImage(cgImage: image, scale: displayScale, orientation: .up))
#endif
            }
        }
        .frame(width: frame.width, height: frame.height)
    }
    
    nonisolated private func createRoundedRectPath(for rect: CGRect, radius: CGFloat) -> CGPath {
        let path = CGMutablePath()
        
        // Start at the top left corner
        path.move(to: CGPoint(x: rect.minX + radius, y: rect.minY))
        
        // Add the top side
        path.addLine(to: CGPoint(x: rect.maxX - radius, y: rect.minY))
        
        // Add the top right corner arc
        path.addArc(center: CGPoint(x: rect.maxX - radius, y: rect.minY + radius), radius: radius,
                    startAngle: CGFloat(3 * Double.pi / 2), endAngle: CGFloat(0), clockwise: false)
        
        // Add the right side
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - radius))
        
        // Add the bottom right corner arc
        path.addArc(center: CGPoint(x: rect.maxX - radius, y: rect.maxY - radius), radius: radius,
                    startAngle: CGFloat(0), endAngle: CGFloat(Double.pi / 2), clockwise: false)
        
        // Add the bottom side
        path.addLine(to: CGPoint(x: rect.minX + radius, y: rect.maxY))
        
        // Add the bottom left corner arc
        path.addArc(center: CGPoint(x: rect.minX + radius, y: rect.maxY - radius), radius: radius,
                    startAngle: CGFloat(Double.pi / 2), endAngle: CGFloat(Double.pi), clockwise: false)
        
        // Add the left side
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + radius))
        
        // Add the top left corner arc
        path.addArc(center: CGPoint(x: rect.minX + radius, y: rect.minY + radius), radius: radius,
                    startAngle: CGFloat(Double.pi), endAngle: CGFloat(3 * Double.pi / 2), clockwise: false)
        
        path.closeSubpath()
        
        return path
    }
    
    
    private init(frame: CGSize, contentMode: ContentMode, source: Source, cornerRadius: CGFloat) {
        self.frame = frame
        self.contentMode = contentMode
        self.source = source
        self.cornerRadius = cornerRadius
    }
    
    /// Creates the image with the given image and the size of presentation.
    ///
    /// - Parameters:
    ///   - frame: The size of presentation. The actual size of the image might be different, as the `displayScale` would be taken into account.
    public init(cgImage: CGImage, frame: CGSize) {
        self.init(frame: frame, contentMode: .fit, source: .image(cgImage), cornerRadius: 0)
    }
    
    /// Creates the image with the given image and the size of presentation.
    ///
    /// - Parameters:
    ///   - frame: The size of presentation. The actual size of the image might be different, as the `displayScale` would be taken into account.
    public init(nativeImage: NativeImage, frame: CGSize) {
        self.init(frame: frame, contentMode: .fit, source: .image(nativeImage.cgImage!), cornerRadius: 0)
    }
    
    /// Creates the image with the given image and the size of presentation.
    ///
    /// - Parameters:
    ///   - frame: The size of presentation. The actual size of the image might be different, as the `displayScale` would be taken into account.
    public init(generator: @escaping @Sendable () async -> CGImage?, frame: CGSize) {
        self.init(frame: frame, contentMode: .fit, source: .generator(generator), cornerRadius: 0)
    }
    
    public func cornerRadius(_ radius: CGFloat) -> AsyncDrawnImage {
        AsyncDrawnImage(frame: self.frame, contentMode: self.contentMode, source: self.source, cornerRadius: radius)
    }
    
    public func contentMode(_ mode: ContentMode) -> AsyncDrawnImage {
        AsyncDrawnImage(frame: self.frame, contentMode: mode, source: self.source, cornerRadius: self.cornerRadius)
    }
    
    
    private enum Source {
        case image(CGImage)
        case generator(@Sendable () async -> CGImage?)
    }
    
}
