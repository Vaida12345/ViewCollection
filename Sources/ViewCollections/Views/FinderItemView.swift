//
//  SwiftUIView.swift
//  The Stratum Module
//
//  Created by Vaida on 5/25/23.
//  Copyright © 2019 - 2024 Vaida. All rights reserved.
//


#if !os(watchOS) && !os(tvOS)
import SwiftUI
import Stratum

/// A preview image of a `FinderItem`.
public struct FinderItemView: View {
    
    // MARK: - Instance Stored Properties
    
    private let item: FinderItem
    
    @State private var preview: Image? = nil
    
    
    // MARK: - Computed Instance Properties
    
    public var body: some View {
        Group {
            if let preview {
                preview
            } else {
                Image(systemName: item.isDirectory ? "folder" : "doc")
                    .imageScale(.large)
            }
        }
            .aspectRatio(contentMode: .fit)
            .onAppear {
                update(url: item.url)
            }
            .onChange(of: item) { newValue in
                update(url: newValue.url)
            }
    }
    
    
    // MARK: - Instance Methods
    
    private func update(url: URL) {
        Task.detached {
            let image = try await FinderItem(at: url).load(.preview(size: .square(64)))
            await __update(image: image)
        }
    }
    
    private nonisolated func __update(image: NativeImage) async {
        let swiftUIImage = Image(nativeImage: image).resizable()
        
        await MainActor.run {
            self.preview = swiftUIImage
        }
    }
    
    
    // MARK: - Designated Initializers
    
    /// Creates a view for the item.
    public init(item: FinderItem) {
        self.item = item
    }
    
}
#endif
