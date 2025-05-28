//
//  SoftPicker.swift
//  ViewCollection
//
//  Created by Vaida on 2025-05-28.
//

import SwiftUI
import ViewCollection


public struct SoftPicker<SelectionValue: Hashable>: View {
    
    @Binding private var selection: SelectionValue
    
    private let options: [SelectionValue]
    
    @Environment(\.softUIShape) private var shape
    
    
    public var body: some View {
        ZStack(alignment: .leading) {
            SoftInnerShadow()
            
            GeometryReader { geometry in
                let selectionWidth = geometry.size.width / Double(options.count)
                
                shape
                    .frame(width: selectionWidth, height: 30)
                    .offset(x: selectionWidth * Double(options.firstIndex(of: selection) ?? 0))
                    .foregroundStyle(.background)
                    .animation(.spring, value: selection)
                
                HStack(spacing: 0) {
                    ForEach(options, id: \.self) { option in
                        Button {
                            selection = option
                        } label: {
                            Text("\(option)")
                                .frame(width: selectionWidth, height: 30)
                                .foregroundStyle(Color.soft.secondary)
                                .fontWeight(.medium)
                                .fontDesign(.rounded)
                                .contentShape(shape)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .frame(height: 30)
    }
    
    public init(selection: Binding<SelectionValue>, options: [SelectionValue]) {
        self._selection = selection
        self.options = options
    }
    
    public init(selection: Binding<SelectionValue>) where SelectionValue: CaseIterable {
        self._selection = selection
        self.options = Array(SelectionValue.allCases)
    }
    
}


#Preview {
    @Previewable @State var selection = 1
    
    SoftPicker(selection: $selection, options: [1, 2, 3, 4])
        .padding()
        .background(Color.soft.main.ignoresSafeArea())
}

