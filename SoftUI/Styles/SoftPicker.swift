//
//  SoftPicker.swift
//  ViewCollection
//
//  Created by Vaida on 2025-05-28.
//

import SwiftUI
import ViewCollection


public struct SoftPicker<SelectionValue: Hashable, Label: View>: View {
    
    @Binding private var selection: SelectionValue
    
    private let options: [SelectionValue]
    
    @Environment(\.softUIShape) private var shape
    @Environment(\.softUIShadowRadius) private var softUIShadowRadius
    
    let label: (_ option: SelectionValue) -> Label
    
    let isAnimated: Bool
    
    @Environment(\.transitionPhase) private var transitionPhase
    var phaseMultiplier: Double {
        guard let transitionPhase else { return isAnimated ? 0 : 1 }
        return transitionPhase == .identity ? 1 : 0
    }
    
    
    public var body: some View {
        ZStack(alignment: .leading) {
            SoftInnerShadow()
                .softShadowRadius((softUIShadowRadius ?? 4) * phaseMultiplier)
            
            GeometryReader { geometry in
                let selectionWidth = geometry.size.width / Double(options.count)
                
                shape
                    .frame(width: selectionWidth, height: 30)
                    .offset(x: selectionWidth * Double(options.firstIndex(of: selection) ?? 0))
                    .foregroundStyle(Color.soft.fill)
                    .animation(.spring, value: selection)
                
                HStack(spacing: 0) {
                    ForEach(options, id: \.self) { option in
                        Button {
                            selection = option
                        } label: {
                            label(option)
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
            .opacity(phaseMultiplier)
        }
        .frame(height: 30)
        .animation(.spring, value: phaseMultiplier)
    }
    
    
    /// Indicates that transitions should be shown on view appear.
    ///
    /// > Warning: When `animated`, the view must attach `transitionPhaseExposing()`
    /// > ```swift
    /// > Button(...)
    /// >     .buttonStyle(.soft(shape: .capsule).animated())
    /// >     .transitionPhaseExposing()
    /// > ```
    public func animated(_ animated: Bool = true) -> SoftPicker {
        SoftPicker(selection: $selection, options: options, isAnimated: animated, label: label)
    }
    
    
    public init(
        selection: Binding<SelectionValue>,
        options: [SelectionValue],
        isAnimated: Bool = false,
        @ViewBuilder label: @escaping (_ option: SelectionValue) -> Label
    ) {
        self._selection = selection
        self.options = options
        self.label = label
        self.isAnimated = isAnimated
    }
    
    public init(
        selection: Binding<SelectionValue>,
        @ViewBuilder label: @escaping (_ option: SelectionValue) -> Label
    ) where SelectionValue: CaseIterable {
        self._selection = selection
        self.options = Array(SelectionValue.allCases)
        self.label = label
        self.isAnimated = false
    }
    
    public init(
        selection: Binding<SelectionValue>,
        options: [SelectionValue],
        @ViewBuilder label: @escaping (_ option: SelectionValue) -> Label = { (option: SelectionValue) in Text("\(option)") }
    ) where Label == Text {
        self._selection = selection
        self.options = options
        self.label = label
        self.isAnimated = false
    }
    
    public init(
        selection: Binding<SelectionValue>,
        @ViewBuilder label: @escaping (_ option: SelectionValue) -> Label = { (option: SelectionValue) in Text("\(option)") }
    ) where SelectionValue: CaseIterable, Label == Text {
        self._selection = selection
        self.options = Array(SelectionValue.allCases)
        self.label = label
        self.isAnimated = false
    }
    
}


#Preview {
    @Previewable @State var selection = 3
    @Previewable @State var phase = 0
    
    VStack {
        SoftPicker(selection: $selection, options: [1, 2, 3, 4]) {
            Text("\($0)++")
        }
        .padding()
        .environment(\.transitionPhase, phase == 0 ? .didDisappear : .identity)
        
        SoftPicker(selection: $phase, options: [0, 1])
        .padding()
        
        Spacer()
    }
    .padding()
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.soft.main.ignoresSafeArea())
}

