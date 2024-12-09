//
//  CrossFadeImage.swift
//  ViewCollection
//
//  Created by Vaida on 12/9/24.
//

import SwiftUI
import NativeImage


/// A view that crossfades when `nativeImage` changes.
///
/// This is different from the default `opacity` transaction as during `opacity` transaction, the image could be semi-transparent.
public struct CrossFadeImage: View {
    
    let image: NativeImage
    
    let contentMode: ContentMode
    
    @State private var lowerImage: NativeImage
    
    @State private var upperImage: NativeImage? = nil
    
    
    public var body: some View {
        ZStack {
            Image(nativeImage: lowerImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .zIndex(-1)
            
            if let upperImage {
                Image(nativeImage: upperImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .zIndex(1)
            }
        }
        .onChange(of: image) { oldValue, newValue in
            // reset state
            self.lowerImage = oldValue
            withAnimation {
                self.upperImage = newValue
            }
        }
    }
    
    public init(nativeImage: NativeImage, contentMode: ContentMode = .fit) {
        self.image = nativeImage
        self.contentMode = contentMode
        self._lowerImage = State(initialValue: image)
        self.upperImage = upperImage
    }
    
}
