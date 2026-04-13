//
//  SegmentedPicker.swift
//  ViewCollection
//
//  Created by Vaida on 2026-04-13.
//

import SwiftUI


public struct SegmentedPicker<Value, AllCases>: View where AllCases: Sequence<Value>, Value: Hashable {
    
    @Binding private var selection: Value
    let allCases: [Value]
    let textForValue: (Value) -> Text
    let shape: AnyShape
    let tint: Color
    
    @Namespace private var namespace
    
    
    public var body: some View {
        GeometryReader { geometry in
            HStack {
                ForEach(allCases, id: \.self) { option in
                    Button {
                        self.selection = option
                    } label: {
                        textForValue(option)
                            .padding(.all, 5)
                            .frame(maxWidth: .infinity)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .background {
                        if selection == option {
                            self.shape
                                .fill(tint)
                                .matchedGeometryEffect(id: 0, in: namespace)
                        }
                    }
                    
                    if option != allCases.last {
                        Divider()
                            .frame(height: 10)
                            .frame(height: 30, alignment: .center)
                    }
                }
            }
        }
        .frame(height: 30)
        .background {
            self.shape
                .fill(.thinMaterial)
        }
    }
    
    
    public init<Shape>(
        selection: Binding<Value>,
        shape: Shape,
        tint: Color
    ) where Value: CaseIterable & CustomLocalizedStringResourceConvertible, AllCases == Value.AllCases, Shape: SwiftUI.Shape {
        self._selection = selection
        self.allCases = Array(Value.allCases)
        self.textForValue = { Text($0.localizedStringResource) }
        self.shape = AnyShape(shape)
        self.tint = tint
    }
    
    public init<Shape>(
        selection: Binding<Value>,
        allCases: AllCases,
        shape: Shape,
        tint: Color,
        label: @escaping (Value) -> Text
    ) where Shape: SwiftUI.Shape {
        self._selection = selection
        self.allCases = Array(allCases)
        self.textForValue = label
        self.shape = AnyShape(shape)
        self.tint = tint
    }
    
}

#if DEBUG
#Preview {
    @Previewable @State var model = _Model.a
    
    SegmentedPicker(selection: $model.animation(), shape: .capsule, tint: .orange)
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
