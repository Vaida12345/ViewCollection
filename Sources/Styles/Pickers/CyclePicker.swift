//
//  CyclePicker.swift
//  ViewCollection
//
//  Created by Vaida on 2025-12-14.
//

import SwiftUI


/// A picker style that cycles the choices on tap.
///
/// - Experiment: When used in a list, you may want to have an `offset` with `x = 2`.
public struct CyclePicker<Value, AllCases>: View where AllCases: Sequence<Value>, Value: Hashable {
    
    @Binding private var selection: Value
    let allCases: AllCases
    let textForValue: (Value) -> Text
    @Untracked private var iterator: AllCases.Iterator
    
    let _convertToNativePicker: Bool
    
    public var body: some View {
        if _convertToNativePicker {
            Picker(selection: $selection) {
                ForEach(Array(allCases), id: \.self) { option in
                    textForValue(option)
                        .tag(option)
                }
            } label: {
                EmptyView()
            }
        } else {
            Button {
                rotate()
            } label: {
                HStack(spacing: 2) {
                    textForValue(selection)
                        .contentTransition(.numericText())
                    Image(systemName: "chevron.up.chevron.down")
                        .scaleEffect(0.75)
                        .fontWeight(.medium)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
    }
    
    func rotate(depth: Int = 0) {
        guard depth < 2 else { return }
        let choice: Value?
        if let next = iterator.next() {
            choice = next
        } else {
            self.iterator = allCases.makeIterator()
            return rotate(depth: depth + 1)
        }
        guard let choice else { return }
        if choice == self.selection {
            return rotate(depth: depth + 1)
        }
        
        withAnimation {
            self.selection = choice
        }
    }
    
    public init(selection: Binding<Value>) where Value: CaseIterable & CustomLocalizedStringResourceConvertible, AllCases == Value.AllCases {
        self._selection = selection
        self.allCases = Value.allCases
        self.textForValue = { Text($0.localizedStringResource) }
        self.iterator = self.allCases.makeIterator()
        _convertToNativePicker = false
    }
    
    public init(selection: Binding<Value>, allCases: AllCases, label: @escaping (Value) -> Text) {
        self._selection = selection
        self.allCases = allCases
        self.textForValue = label
        self.iterator = self.allCases.makeIterator()
        _convertToNativePicker = false
    }
    
    init(selection: Binding<Value>, allCases: AllCases, label: @escaping (Value) -> Text, convertToNativePicker: Bool) {
        self._selection = selection
        self.allCases = allCases
        self.textForValue = label
        self._convertToNativePicker = convertToNativePicker
        self.iterator = self.allCases.makeIterator()
    }
    
    #if os(macOS)
    public func convertToNativePicker(_ bool: Bool = true) -> CyclePicker {
        CyclePicker(selection: $selection, allCases: allCases, label: textForValue, convertToNativePicker: bool)
    }
    #endif
}

#if DEBUG
#Preview {
    @Previewable @State var model = _Model.a
    
    VStack {
        CyclePicker(selection: $model)
#if os(macOS)
            .convertToNativePicker()
            .pickerStyle(.inline)
#else
            .foregroundStyle(.blue)
#endif
    }
    .padding()
}

private enum _Model: CaseIterable, CustomLocalizedStringResourceConvertible {
    case a, b, c
    
    var localizedStringResource: LocalizedStringResource {
        switch self {
        case .a: "a"
        case .b: "b"
        case .c: "c"
        }
    }
}
#endif
