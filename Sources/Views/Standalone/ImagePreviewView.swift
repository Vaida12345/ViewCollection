//
//  ImagePreviewView.swift
//  The ViewCollection Module
//
//  Created by Vaida on 2024/1/26.
//  Copyright © 2019 - 2024 Vaida. All rights reserved.
//

import Foundation
import SwiftUI
import NativeImage


/// A view providing zoomable preview to an image.
///
/// When implementing the view. Keep in mind that
/// - The `matchedGeometryEffect` should only applied to one id at a time, hence the `if`s.
/// - Use `zIndex` to achieve a smooth transition of the material background.
///
/// ```swift
/// struct ContentView: View {
///
///     @Namespace var nameSpace
///     let image = Image(systemName: "faceid")
///     @State private var showImage = false
///
///     var body: some View {
///         ZStack {
///             Button {
///                  withAnimation {
///                      showImage.toggle()
///                  }
///              } label: {
///                  if !showImage {
///                      image
///                          .matchedGeometryEffect(id: ImagePreviewView.nameSpaceID, in: nameSpace)
///                  }
///              }
///             .zIndex(-1)
///
///             if showImage {
///                 ImagePreviewView(image: UIImage(systemName: "faceid")!, nameSpace: nameSpace) {
///                     withAnimation(.interpolatingSpring) {
///                         showImage = false
///                     }
///                 }
///             }
///         }
///     }
/// }
/// ```
///
/// ![Example View](imagePreviewView)
@available(iOS, introduced: 18.0)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public struct ImagePreviewView: View {
    
    private let image: NativeImage
    
    private let onDelete: (() -> Void)?
    
    private let nameSpace: Namespace.ID
    
#if os(iOS)
    @StateObject private var scrollCoordinator: ScrollController.Coordinator
#endif
    
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    
#if os(iOS)
    private var imageView: some View {
        ScrollController(image: image, coordinator: scrollCoordinator)
            .ignoresSafeArea()
            .scaleEffect(scrollCoordinator.zoomScale != 1 ? 1 : 0.8 + 0.2 * (1 - scrollCoordinator.swapProgress))
            .matchedGeometryEffect(id: ImagePreviewView.nameSpaceID, in: nameSpace)
            .matchedGeometryEffect(id: "ImagePreviewView.imageView", in: nameSpace)
    }
#endif
    
    private var controls: some View {
        Group {
            Button {
#if os(iOS)
                scrollCoordinator.onReturn()
#endif
            } label: {
                Label("Return", systemImage: "arrow.down", bundle: .module)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity)
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
            .matchedGeometryEffect(id: "ImagePreviewView.controls.return", in: nameSpace)
#if os(iOS)
            .onChange(of: scrollCoordinator.zoomScale) { oldValue, newValue in
                print(newValue)
            }
#endif
            
            if let onDelete {
                Button {
                    onDelete()
                } label: {
                    Label("Remove", systemImage: "trash", bundle: .module)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity)
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
                .matchedGeometryEffect(id: "ImagePreviewView.controls.delete", in: nameSpace)
            }
        }
        .animation(.interpolatingSpring, value: verticalSizeClass)
        .transition(.offset(y: 100).combined(with: .opacity).combined(with: .scale))
#if os(iOS)
        .opacity(0.25 + (1 - scrollCoordinator.swapProgress) * 0.75)
#endif
    }
    
    
    public var body: some View {
        ZStack(alignment: verticalSizeClass == .regular ? .bottom : .trailing) {
#if os(iOS)
            imageView
                .zIndex(-1)
#endif
            
            let layout = verticalSizeClass == .regular ? AnyLayout(EqualWidthHStack(spacing: 25)) : AnyLayout(EqualWidthVStack(spacing: 25))
            
            layout {
                controls
            }
            .padding(.all, 5)
        }
        .animation(.interpolatingSpring, value: verticalSizeClass)
#if os(iOS)
        .onSwipe(to: .bottom, progress: $scrollCoordinator.swapProgress, disabled: scrollCoordinator.zoomScale != 1) {
            scrollCoordinator.onReturn()
        }
#endif
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Rectangle()
                .fill(.regularMaterial)
#if os(iOS)
                .opacity(0.5 + (1 - scrollCoordinator.swapProgress) * 0.5)
#endif
                .ignoresSafeArea()
        }
    }
    
    
    /// Creates the Image Preview.
    ///
    /// - Parameters:
    ///   - image: The image to be shown.
    ///   - onReturn: The handler when the preview should be dismissed.
    ///   - onDelete: The optional handler when the `image` should be deleted
    ///   - nameSpace: The namespace containing ``ImagePreviewView/nameSpaceID``. Used for smooth transition.
    public init(image: NativeImage, nameSpace: Namespace.ID, onReturn: @escaping () -> Void, onDelete: (() -> Void)? = nil) {
        self.image = image
        self.nameSpace = nameSpace
        self.onDelete = onDelete
#if os(iOS)
        self._scrollCoordinator = StateObject(wrappedValue: .init(onReturn: onReturn))
#endif
    }

    
    /// The namespace ID associated with the image.
    ///
    /// The ID can be used inside `matchedGeometryEffect` to provide a smooth transition of image.
    public static let nameSpaceID = "ImagePreviewView.image"
    
#if os(iOS)
    private struct ScrollController: UIViewRepresentable {
        
        private let image: UIImage
        
        private let coordinator: Coordinator
        
        fileprivate func makeUIView(context: Context) -> UIScrollView {
            let scrollView = UIScrollView()
            scrollView.delegate = context.coordinator
            
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            imageView.frame.size = UIScreen.main.bounds.size
            
            scrollView.addSubview(imageView)
            scrollView.contentSize = imageView.frame.size
            scrollView.isScrollEnabled = false
            scrollView.showsVerticalScrollIndicator = false
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.maximumZoomScale = 5
            scrollView.minimumZoomScale = 0.5
            scrollView.frame = UIScreen.main.bounds
            
            NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification,
                                                   object: nil,
                                                   queue: .main) { notification in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    UIView.animate(withDuration: 1) {
                        scrollView.contentSize = UIScreen.main.bounds.size
                        scrollView.frame = UIScreen.main.bounds
                        imageView.frame = UIScreen.main.bounds
                    }
                }
            }
            
            return scrollView
        }
        
        fileprivate func updateUIView(_ uiView: UIScrollView, context: Context) {
            
        }
        
        
        fileprivate init(image: UIImage, coordinator: Coordinator) {
            self.image = image
            self.coordinator = coordinator
        }
        
        
        fileprivate typealias UIViewType = UIScrollView
        
        fileprivate final class Coordinator: NSObject, UIScrollViewDelegate, ObservableObject {
            
            @Published fileprivate var zoomScale: Double = 1
            
            @Published fileprivate var swapProgress: Double = 0
            
            fileprivate let onReturn: () -> Void
            
            
            fileprivate func viewForZooming(in scrollView: UIScrollView) -> UIView? {
                scrollView.subviews.first
            }
            
            fileprivate func scrollViewDidZoom(_ scrollView: UIScrollView) {
                self.zoomScale = scrollView.zoomScale
                
                scrollView.isScrollEnabled = zoomScale <= 1
                if zoomScale == 0.5 {
                    onReturn()
                } else if zoomScale < 1 {
                    swapProgress = (2 - 2 * zoomScale)
                }
            }
            
            fileprivate func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
                if scale > 0.5 && scale < 1 {
                    scrollView.setZoomScale(1, animated: true) // not yet
                    self.zoomScale = 1
                    self.swapProgress = 0
                }
            }
            
            fileprivate init(onReturn: @escaping () -> Void) {
                self.onReturn = onReturn
            }
            
        }
        
        fileprivate func makeCoordinator() -> Coordinator {
            self.coordinator
        }
        
    }
#endif
    
}

#if os(iOS)
#Preview {
    @Previewable @State var showImage = true
    
    @Previewable @Namespace var nameSpace
    
    let image = Image(systemName: "faceid")
    
    
    ZStack {
        VStack {
            Spacer()
            
            Button {
                withAnimation {
                    showImage.toggle()
                }
            } label: {
                if !showImage {
                    image
                        .matchedGeometryEffect(id: ImagePreviewView.nameSpaceID, in: nameSpace)
                }
            }
        }
        .zIndex(-1)
        
        if showImage {
            ImagePreviewView(image: UIImage(systemName: "faceid")!, nameSpace: nameSpace) {
                showImage = false
            } onDelete: {
                
            }
        }
    }
}
#endif
