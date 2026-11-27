//
//  PreviewSheet.swift
//  ViewCollection
//
//  Created by Vaida on 2026-11-14.
//

import SwiftUI


/// A sheet presentation design for previews.
///
/// - Note this does nothing on macOS, as macOS does not support sheet previews.
public struct PreviewSheet<Content: View>: View {
    
#if !os(macOS)
    @State private var isSheetPresented: Bool = true
#endif
    
    let content: @MainActor () -> Content
    
    public var body: some View {
#if os(macOS)
        content()
#else
        Toggle(isOn: $isSheetPresented) {
            Text(verbatim: "Show Sheet")
        }
        .sheet(isPresented: $isSheetPresented) {
            content()
        }
#endif
    }
    
    public init(content: @MainActor @escaping () -> Content) {
        self.content = content
    }
}
