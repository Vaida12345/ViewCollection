//
//  FloatingSheetModifier.swift
//  ViewCollection
//
//  Created by Vaida on 12/1/24.
//

#if !os(macOS) && !os(visionOS)
import SwiftUI


fileprivate struct FloatingSheetModifier<Overlay: View>: ViewModifier {
    
    @Binding var isPresented: Bool
    
    @State private var dismissProgress: Double = 0
    
    let onDismiss: (() -> Void)?
    
    let content: () -> Overlay
    
    @Environment(\.colorScheme) private var colorScheme
    
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .zIndex(-1)
                .disabled(isPresented)
            
            Group {
                // Dimmed background
                if isPresented {
                    Rectangle()
                        .fill(.regularMaterial)
                        .ignoresSafeArea()
                        .transition(.opacity)
                        .opacity(1 - dismissProgress)
                }
                
                // Floating sheet
                if isPresented {
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
                                .fill(Color(UIColor.systemBackground))
                                .shadow(radius: 10)
                        )
                        .overlay(alignment: .topTrailing) {
                            Button {
                                onDismiss?()
                                withAnimation {
                                    isPresented = false
                                }
                            } label: {
                                ZStack {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundStyle(colorScheme == .dark ? .white.opacity(0.7) : .black.opacity(0.6))
                                        .shadow(radius: 1)
                                        .fontWeight(.semibold)
                                        .imageScale(.large)
                                }
                            }
                            .padding()
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
                    .onAppear {
                        self.dismissProgress = 0
                    }
                }
            }
        }
    }
}

@available(macOS, unavailable)
@available(visionOS, unavailable)
extension View {
    
    /// A floating sheet on iOS.
    ///
    /// To dismiss a floating sheet, use the ``SwiftUICore/EnvironmentValues/dismissFloatingSheet`` environment key.
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

#Preview {
    @Previewable @State var width: Double = 100
    
    @Previewable @State var showsSheet: Bool = true
    
    Toggle("Show Sheet", isOn: $showsSheet.animation())
        .floatingSheet(isPresented: $showsSheet) {
            Text("Sheet")
                .padding(.horizontal)
                .frame(width: 400)
        }
}
#endif

extension EnvironmentValues {
    
    /// Dismiss a ``SwiftUICore/View/floatingSheet(isPresented:onDismiss:content:)``.
    @Entry public var dismissFloatingSheet: () -> Void = { }
    
}
