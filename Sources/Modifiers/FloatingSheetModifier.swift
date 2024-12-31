//
//  FloatingSheetModifier.swift
//  ViewCollection
//
//  Created by Vaida on 12/1/24.
//

#if os(iOS)
import SwiftUI

@available(iOS 17, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
fileprivate struct FloatingSheetModifier<Overlay: View>: ViewModifier {
    
    @Binding var isPresented: Bool
    
    let onDismiss: (() -> Void)?
    let content: () -> Overlay
    
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .zIndex(-1)
                .disabled(isPresented)
            
            if isPresented {
                // Use a new view to create a new identity on the conditional branch. In this case, when `isPresented` is set to `false`, the view, along with its states, is deallocated.
                // This can be used to reset the states.
                FloatingSheetOverlay(isPresented: $isPresented, onDismiss: onDismiss, content: self.content)
            }
        }
    }
}

@available(iOS 17, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
fileprivate struct FloatingSheetOverlay<Overlay: View>: View {
    
    @State private var dismissProgress: Double = 0
    @Binding var isPresented: Bool
    
    let onDismiss: (() -> Void)?
    let content: () -> Overlay
    
    
    var body: some View {
        ZStack {
            // Dimmed background
            Rectangle()
                .fill(.regularMaterial)
                .ignoresSafeArea()
                .transition(.opacity)
                .opacity(1 - dismissProgress)
            
            // Floating sheet
            VStack {
                VStack {
                    self.content()
                        .environment(\.dismissFloatingSheet, {
                            withAnimation {
                                self.isPresented = false
                            }
                        })
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.background)
                        .shadow(radius: 10)
                )
                .overlay(alignment: .topTrailing) {
                    Button {
                        onDismiss?()
                        withAnimation {
                            isPresented = false
                        }
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .buttonStyle(.circular)
                    .padding([.top, .trailing], 10)
                }
            }
            .padding()
            .transition(.move(edge: .bottom).combined(with: .opacity))
            .animation(.spring, value: isPresented) // animate no matter what
            .ignoresSafeArea()
            .onSwipe(to: .bottom, progress: $dismissProgress) {
                onDismiss?()
                withAnimation {
                    isPresented = false
                }
            }
        }
    }
}

@available(iOS 17, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension View {
    
    /// A floating sheet on iOS.
    ///
    /// To dismiss a floating sheet, use the ``SwiftUICore/EnvironmentValues/dismissFloatingSheet`` environment key.
    ///
    /// ![preview](floatingSheet)
    public func floatingSheet<Content: View>(
        isPresented: Binding<Bool>,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        self.modifier(
            FloatingSheetModifier(
                isPresented: isPresented,
                onDismiss: onDismiss,
                content: content
            )
        )
    }
}

#Preview("Floating Sheet") {
    @Previewable @State var width: Double = 100
    
    @Previewable @State var showsSheet: Bool = true
    
    Toggle("Show Sheet", isOn: $showsSheet.animation())
        .floatingSheet(isPresented: $showsSheet) {
            Text("Sheet")
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
                .frame(height: 100)
        }
}

#Preview("FloatingSheetOverlay") {
    FloatingSheetOverlay(isPresented: .constant(true), onDismiss: nil) {
        Text("Sheet")
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
            .frame(height: 100)
    }
}


@available(iOS 17, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension EnvironmentValues {
    
    /// Dismiss a ``SwiftUICore/View/floatingSheet(isPresented:onDismiss:content:)``.
    @Entry public var dismissFloatingSheet: () -> Void = { }
    
}
#endif
