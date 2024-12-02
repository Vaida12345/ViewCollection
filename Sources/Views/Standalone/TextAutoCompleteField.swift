//
//  TextAutoCompleteField.swift
//  The ViewCollection Module
//
//  Created by Vaida on 6/27/23.
//  Copyright © 2019 - 2024 Vaida. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import SwiftUI
import AppKit


/// A text field that would autocomplete using the given `options`.
public struct TextAutoCompleteField: View {
    
    private let titleKey: LocalizedStringKey
    private let options: [String]
    @Binding private var text: String
    
    @State private var currentCount = 0
    /// Flag of whether the text update is caused by this view.
    @State private var updateTextFlag = 0
    
    
    public var body: some View {
        TextField(titleKey, text: $text)
            .onReceive(NotificationCenter.default.publisher(for: NSTextField.textDidChangeNotification)) { newValue in
                guard let field = newValue.object else { return }
                guard let window = NSApplication.shared.windows.first(where: { $0.fieldEditor(false, for: field)?.string != nil }),
                      let textField = window.fieldEditor(false, for: field) else { return }
                
                guard updateTextFlag == 0 else {
                    textField.selectedRange = NSRange(location: updateTextFlag, length: self.text.count - updateTextFlag)
                    updateTextFlag = 0
                    return
                }
                
                let oldValue = textField.string
                guard oldValue.count > currentCount else { currentCount = oldValue.count; return }
                guard let first = self.options.first(where: { $0.lowercased().contains(oldValue.lowercased()) }) else { return }
                currentCount = oldValue.count
                
                self.updateTextFlag = oldValue.count
                self.text = first
            }
    }
    
    
    /// Creates a field.
    ///
    /// - Parameters:
    ///   - titleKey: The title used as placeholder.
    ///   - text: The text to display and edit.
    ///   - options: The candidates.
    public init(_ titleKey: LocalizedStringKey, text: Binding<String>, options: [String]) {
        self.titleKey = titleKey
        self._text = text
        self.options = options
    }
    
}
#endif
