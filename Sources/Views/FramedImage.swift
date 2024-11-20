//
//  FramedImage.swift
//  icon generator
//
//  Created by Vaida on 6/6/22.
//

import Foundation
import SwiftUI
import NativeImage


public struct FramedImage: View {
    
    private let image: CGImage
    
    private let parameters: Parameters
    
    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: parameters.cornerRadius + parameters.margin)
                .fill(.white)
                .frame(width: parameters.imageSize.width + 2 * parameters.margin,
                       height: parameters.imageSize.height + 2 * parameters.margin)
                .shadow(radius: parameters.shadowRadius, x: parameters.shadowOffset.x, y: parameters.shadowOffset.y)
            
            ZStack {
                Image(decorative: image, scale: 1)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: parameters.imageSize.width, height: parameters.imageSize.height)
                
                RoundedRectangle(cornerRadius: parameters.cornerRadius)
                    .stroke(
                        parameters.innerShadowColor,
                        style: StrokeStyle(
                            lineWidth: parameters.innerShadowLineWidth,
                            lineCap: .round,
                            lineJoin: .miter
                        )
                    )
                    .frame(width: parameters.imageSize.width, height: parameters.imageSize.height)
            }
            .clipped()
            .cornerRadius(parameters.cornerRadius)
        }
        .frame(width: parameters.cavasSize.width, height: parameters.cavasSize.height)
    }
    
    public func rendered() -> CGImage? {
        let renderer = ImageRenderer(content: self)
        renderer.proposedSize = .init(parameters.cavasSize)
        return renderer.cgImage
    }
    
    public nonisolated init(image: CGImage, format: Format) async {
        let cgImage = image
        self.parameters = format.parameters
        
        guard let cgImage = await cgImage.fill(in: parameters.imageSize, type: .attentionBased) else {
            self.image = image
            return
        }
        
        self.image = cgImage
    }
    
    public nonisolated init(image: NativeImage, format: Format) async {
        await self.init(image: image.cgImage!, format: format)
    }
    
    fileprivate struct Parameters {
        let cornerRadius: CGFloat
        let margin: CGFloat
        
        let cavasSize: CGSize
        let imageSize: CGSize
        
        let shadowRadius: CGFloat
        let shadowOffset: CGPoint
        
        let innerShadowColor: Color
        let innerShadowLineWidth: CGFloat
        
        init(
            cornerRadius: CGFloat = 100,
            margin: CGFloat = 30,
            cavasSize: CGSize = CGSize(width: 1350, height: 1350),
            imageSize: CGSize = CGSize(width: 1130, height: 1130),
            shadowRadius: CGFloat = 20,
            shadowOffset: CGPoint = CGPoint(x: 5, y: 5),
            innerShadowColor: SwiftUICore.Color = Color.black.opacity(0.2),
            innerShadowLineWidth: CGFloat = 5
        ) {
            self.cornerRadius = cornerRadius
            self.margin = margin
            self.cavasSize = cavasSize
            self.imageSize = imageSize
            self.shadowRadius = shadowRadius
            self.shadowOffset = shadowOffset
            self.innerShadowColor = innerShadowColor
            self.innerShadowLineWidth = innerShadowLineWidth
        }
    }
    
    public enum Format: CustomStringConvertible {
        case landscape, portrait, square
        
        public var description: String {
            switch self {
            case .square:
                "Square"
            case .portrait:
                "Portrait"
            case .landscape:
                "LandScape"
            }
        }
        
        fileprivate var parameters: Parameters {
            switch self {
            case .square:
                Parameters()
            case .portrait:
                Parameters(
                    cornerRadius: 40,
                    imageSize: CGSize(width: 800, height: 1130)
                )
            case .landscape:
                Parameters(
                    cornerRadius: 40,
                    imageSize: CGSize(width: 1130, height: 636)
                )
            }
        }
        
        public var systemName: String {
            switch self {
            case .square:
                "square.inset.filled"
            case .portrait:
                "rectangle.portrait.inset.filled"
            case .landscape:
                "rectangle.inset.filled"
            }
        }
    }
    
}

#Preview {
    ZStack {
        Color.white
        AsyncView {
            await FramedImage(image: NativeImage(contentsOfFile: "/Users/vaida/Library/Mobile Documents/com~apple~CloudDocs/DataBase/Animation/Pictures/2.heic")!.cgImage!, format: .square)
        } content: {
            $0
        }
        .frame(width: 1350, height: 1350)
    }
}
