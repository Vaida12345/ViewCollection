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
    
    
    public var body: some View {
        VStack {
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .matchedGeometryEffect(id: ImagePreviewView.nameSpaceID, in: nameSpace)
                .cornerRadius(5)
                .frame(maxHeight: 300)
                .padding()
            
            HStack {
                Button {
                    onReturn()
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
                        onDelete()
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
            .transition(.move(edge: .bottom).combined(with: .opacity))
        }
//        .onSwap(to: .bottom) {
//            onReturn()
//        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.regularMaterial)
        .ignoresSafeArea()
    }
    
    
    /// Creates the Image Preview.
    ///
    /// - Parameters:
    ///   - image: The image to be shown.
    ///   - onReturn: The handler when the preview should be dismissed.
    ///   - onDelete: The optional handler when the `image` should be deleted
    ///   - nameSpace: The namespace containing ``ImagePreviewView/nameSpaceID``. Used for smooth transition.
    public init(image: Image, onReturn: @escaping () -> Void, onDelete: (() -> Void)? = nil, nameSpace: Namespace.ID) {
        self.image = image
        self.onReturn = onReturn
        self.onDelete = onDelete
        self.nameSpace = nameSpace
    }

    
    /// The namespace ID associated with the image.
    ///
    /// The ID can be used inside `matchedGeometryEffect` to provide a smooth transition of image.
    public static let nameSpaceID = "ImagePreviewView.image"
    
}

#Preview {
    @Namespace var nameSpace
    
    if #available(iOS 17, *) {
        return ImagePreviewView(image: Image(systemName: "faceid"), onReturn: {}, onDelete: {}, nameSpace: nameSpace)
    } else {
        return EmptyView()
    }
}

#endif
