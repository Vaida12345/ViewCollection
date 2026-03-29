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
@available(iOS 17, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public struct CyclePicker<Value, AllCases>: View where AllCases: Sequence<Value> {
    
    @Binding private var selection: Value
    let allCases: AllCases
    let textForValue: (Value) -> Text
    @Untracked private var iterator: AllCases.Iterator
    
    public var body: some View {
        Button {
            let choice: Value?
            if let next = iterator.next() {
                choice = next
            } else {
                self.iterator = allCases.makeIterator()
                choice = self.iterator.next()
            }
            guard let choice else { return }
            
            withAnimation {
                self.selection = choice
            }
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
    
    public init(selection: Binding<Value>) where Value: CaseIterable & CustomLocalizedStringResourceConvertible, AllCases == Value.AllCases {
        self._selection = selection
        self.allCases = Value.allCases
        self.textForValue = { Text($0.localizedStringResource) }
        self.iterator = self.allCases.makeIterator()
    }
    
    public init(selection: Binding<Value>, allCases: AllCases, label: @escaping (Value) -> Text) {
        self._selection = selection
        self.allCases = allCases
        self.textForValue = label
        self.iterator = self.allCases.makeIterator()
    }
    
}

#if DEBUG && os(iOS)
#Preview {
    @Previewable @State var model = _Model.a
    
    VStack {
        CyclePicker(selection: $model)
            .foregroundStyle(.blue)
        
//        Picker(selection: $model)
    }
    .padding()
    .scaleEffect(5)
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
