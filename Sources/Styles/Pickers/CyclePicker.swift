//
//  CyclePicker.swift
//  ViewCollection
//
//  Created by Vaida on 2025-12-14.
//

import SwiftUI


/// A picker style that cycles the choices on tap.
///
/// - Experiment: When used in in a list, you may want to have an `offset` with `x = 2`.
@available(iOS 17, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public struct CyclePicker<Selection>: View where Selection: CaseIterable & CustomLocalizedStringResourceConvertible {
    
    @Binding private var selection: Selection
    @Untracked private var iterator: Selection.AllCases.Iterator
    
    public var body: some View {
        Button {
            let choice: Selection?
            if let next = iterator.next() {
                choice = next
            } else {
                self.iterator = Selection.allCases.makeIterator()
                choice = self.iterator.next()
            }
            guard let choice else { return }
            
            withAnimation {
                self.selection = choice
            }
        } label: {
            HStack(spacing: 2) {
                Text(selection.localizedStringResource)
                    .contentTransition(.numericText())
                Image(systemName: "chevron.up.chevron.down")
                    .scaleEffect(0.75)
                    .fontWeight(.medium)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
    
    public init(selection: Binding<Selection>) {
        self._selection = selection
        self.iterator = Selection.allCases.makeIterator()
    }
    
}

#if DEBUG && os(iOS)
#Preview {
    @Previewable @State var model = _Model.a
    
    VStack {
        CyclePicker(selection: $model)
        
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
