//
//  PreviewSheet.swift
//  ViewCollection
//
//  Created by Vaida on 2026-11-14.
//

import SwiftUI


/// A sheet presentation design for previews.
public struct PreviewSheet<Content: View>: View {
    
    @State private var isSheetPresented: Bool = true
    
    let content: @MainActor () -> Content
    
    public var body: some View {
        Toggle(isOn: $isSheetPresented) {
            Text(verbatim: "Show Sheet")
        }
        .sheet(isPresented: $isSheetPresented) {
            content()
        }
    }
    
    public init(content: @MainActor @escaping () -> Content) {
        self.content = content
    }
}
