//
//  FormattedTextField.swift
//  ViewCollection
//
//  Created by Vaida on 2025-10-13.
//

import SwiftUI


/// Presents a formatted TextField that is suitable in `GroupBox`.
///
/// ```swift
/// let format = FloatingPointFormatStyle<Double>.number.scale(100).precision(0)
/// FormattedTextField("", value: $value, default: 0, format: format, suffix: "%") {
///     Text("x")
/// }
/// ```
///
/// ![Preview](FormattedTextField)
public struct FormattedTextField<F, Label: View>: View where F : ParseableFormatStyle, F.FormatOutput == String {
    
    let titleKey: LocalizedStringKey
    
    @Binding var value: F.FormatInput
    
    let defaultValue: F.FormatInput
    
    let format: F
    
    let suffix: String
    
    let label: Label
    
    
    @State private var onHover = false
    @FocusState private var isFocused: Bool
    
    
    public var body: some View {
        HStack(spacing: 0) {
            Group {
                if onHover {
                    label.hidden()
                } else {
                    label
                }
            }
            .foregroundStyle(.secondary)
            .scaleEffect(0.75, anchor: .bottom)
            
            TextField(titleKey, value: $value, format: format)
                .multilineTextAlignment(.trailing)
                .textFieldStyle(.plain)
                .focused($isFocused)
            
            Text(suffix)
                .foregroundStyle(.secondary)
                .scaleEffect(0.75, anchor: .bottom)
        }
        .overlay(alignment: .leading) {
            if onHover {
                Button {
                    self.value = self.defaultValue
                } label: {
                    SwiftUI.Label("Reset", systemImage: "arrow.counterclockwise")
                        .labelStyle(.iconOnly)
                        .scaleEffect(0.9)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 5)
        .padding(.vertical, 3)
        .background {
            RoundedRectangle(cornerRadius: 5)
                .stroke(.quaternary, lineWidth: 0.5)
                .fill(isFocused ? AnyShapeStyle(.background) : AnyShapeStyle(.quaternary))
        }
        .onHover { hover in
            withAnimation(.default.speed(3)) {
                self.onHover = hover
            }
        }
    }
    
    
    public init(_ titleKey: LocalizedStringKey, value: Binding<F.FormatInput>, default: F.FormatInput, format: F, suffix: String, @ViewBuilder label: () -> Label = { EmptyView() }) {
        self.titleKey = titleKey
        self._value = value
        self.defaultValue = `default`
        self.format = format
        self.suffix = suffix
        self.label = label()
    }
    
}


#Preview {
    @Previewable @State var value: Double = 0.93
    
    let format = FloatingPointFormatStyle<Double>.number.scale(100).precision(1)
    FormattedTextField("", value: $value, default: 0, format: format, suffix: "%") {
        Text("x")
    }
    .frame(width: 100)
    .padding()
}

