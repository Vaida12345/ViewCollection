//
//  ImagePreviewView.swift
//  The ViewCollection Module
//
//  Created by Vaida on 2024/1/26.
//  Copyright © 2019 - 2024 Vaida. All rights reserved.
//


#if canImport(UIKit)
import Foundation
import SwiftUI


/// A view providing zoomable preview to an image.
@available(iOS 17, *)
public struct ImagePreviewView: View {
    
    private let image: Image
    
    private let onReturn: () -> Void
    
    private let onDelete: (() -> Void)?
    
    private let nameSpace: Namespace.ID
    
    @State private var swapProgress: Double = 0
    
    
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    
    
    private var imageView: some View {
        image
            .resizable()
            .scaledToFit()
            .cornerRadius(5)
            .scaleEffect(.square(0.8 + 0.2 * (1 - swapProgress)))
            .matchedGeometryEffect(id: ImagePreviewView.nameSpaceID, in: nameSpace)
            .padding()
            .matchedGeometryEffect(id: "ImagePreviewView.imageView", in: nameSpace)
    }
    
    private var controls: some View {
        Group {
            Button {
                withAnimation(.interpolatingSpring) {
                    onReturn()
                }
            } label: {
                Label("Return", systemImage: "arrow.down")
                    .padding(.horizontal, 13)
                    .padding(.vertical, 8)
                    .background {
                        Capsule()
                            .strokeBorder(style: .init(), antialiased: true)
                            .foregroundStyle(.ultraThickMaterial)
                    }
                    .background {
                        Capsule()
                            .fill(.ultraThinMaterial.opacity(0.5))
                    }
            }
            
            if let onDelete {
                Button {
                    withAnimation(.interpolatingSpring) {
                        onDelete()
                    }
                } label: {
                    Label("Remove", systemImage: "trash")
                        .padding(.horizontal, 13)
                        .padding(.vertical, 8)
                        .background {
                            Capsule()
                                .strokeBorder(style: .init(), antialiased: true)
                                .foregroundStyle(.ultraThickMaterial)
                        }
                        .background {
                            Capsule()
                                .fill(.ultraThinMaterial.opacity(0.5))
                        }
                        .foregroundStyle(.red)
                }
            }
        }
        .matchedGeometryEffect(id: "ImagePreviewView.controls", in: nameSpace)
        .animation(.interpolatingSpring, value: verticalSizeClass)
        .transition(.offset(y: 100).combined(with: .opacity).combined(with: .scale))
        .opacity(0.25 + (1 - swapProgress) * 0.75)
    }
    
    
    public var body: some View {
        Group {
            if verticalSizeClass == .regular {
                VStack {
                    imageView
                    
                    HStack {
                        controls
                    }
                    .padding()
                }
            } else {
                HStack {
                    imageView
                    
                    VStack {
                        controls
                    }
                    .padding()
                }
            }
        }
        .animation(.interpolatingSpring, value: verticalSizeClass)
        .onSwap(to: .bottom, progress: $swapProgress) {
            withAnimation(.interpolatingSpring) {
                onReturn()
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.regularMaterial.opacity(0.5 + (1 - swapProgress) * 0.5))
        .ignoresSafeArea()
    }
    
    
    /// Creates the Image Preview.
    ///
    /// - Parameters:
    ///   - image: The image to be shown.
    ///   - onReturn: The handler when the preview should be dismissed.
    ///   - onDelete: The optional handler when the `image` should be deleted
    ///   - nameSpace: The namespace containing ``ImagePreviewView/nameSpaceID``. Used for smooth transition.
    public init(image: Image, nameSpace: Namespace.ID, onReturn: @escaping () -> Void, onDelete: (() -> Void)? = nil) {
        self.image = image
        self.nameSpace = nameSpace
        self.onReturn = onReturn
        self.onDelete = onDelete
    }

    
    /// The namespace ID associated with the image.
    ///
    /// The ID can be used inside `matchedGeometryEffect` to provide a smooth transition of image.
    public static let nameSpaceID = "ImagePreviewView.image"
    
}


#Preview {
    @Namespace var nameSpace
    
    if #available(iOS 17, *) {
        return ImagePreviewView(image: Image(systemName: "faceid"), nameSpace: nameSpace, onReturn: {}, onDelete: {})
    } else {
        return EmptyView()
    }
}

#endif
