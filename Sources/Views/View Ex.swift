//
//  View & SwiftUI Extensions.swift
//  The Stratum Module
//
//  Created by Vaida on 6/22/22.
//  Copyright © 2019 - 2024 Vaida. All rights reserved.
//

import Accelerate
import SwiftUI


public extension Picker {
    
    /// Initialize a picker with its `options`.
    ///
    /// - Parameters:
    ///   - title: A localized string key that describes the purpose of selecting an option.
    ///   - selection: A binding to a property that determines the currently-selected option.
    ///   - options: A set of options that builds a `ForEach` view.
    @inlinable
    init(_ title: LocalizedStringKey, selection: Binding<SelectionValue>, options: [SelectionValue]) where SelectionValue: CustomStringConvertible, Label == Text, Content == ForEach<[SelectionValue], SelectionValue, Text> {
        self.init(title, selection: selection) {
            ForEach(options, id: \.self) {
                Text(LocalizedStringKey($0.description))
            }
        }
    }
    
    /// Initialize a picker with its `options`.
    ///
    /// - Parameters:
    ///   - title: A localized string key that describes the purpose of selecting an option.
    ///   - selection: A binding to a property that determines the currently-selected option.
    ///   - options: A set of options that builds a `ForEach` view.
    @inlinable
    init(_ title: LocalizedStringKey = "", selection: Binding<SelectionValue>, options: [SelectionValue]) where SelectionValue: RawRepresentable, SelectionValue.RawValue == String, Label == Text, Content == ForEach<[SelectionValue], SelectionValue, Text> {
        self.init(title, selection: selection) {
            ForEach(options, id: \.self) {
                Text(LocalizedStringKey($0.rawValue))
            }
        }
    }
    
    /// Initialize a picker with a `CaseIterable` enumeration, whose rawValue is string.
    ///
    /// - Remark: The set of options that builds a `ForEach` view are generated from `allCases`.
    ///
    /// - Parameters:
    ///   - title: A localized string key that describes the purpose of selecting an option.
    ///   - selection: A binding to a property that determines the currently-selected option.
    @inlinable
    init(_ title: LocalizedStringKey = "", selection: Binding<SelectionValue>) where SelectionValue: RawRepresentable, SelectionValue.RawValue == String, SelectionValue: CaseIterable, Label == Text, Content == ForEach<SelectionValue.AllCases, SelectionValue, Text> {
        self.init(title, selection: selection) {
            ForEach(SelectionValue.allCases, id: \.self) {
                Text(LocalizedStringKey($0.rawValue))
            }
        }
    }
    
}


public extension View {
    
    /// The mask that does the opposite of `mask(_:,_:)`.
    @inlinable
    func reverseMask<Mask: View>(alignment: Alignment = .center, @ViewBuilder _ mask: () -> Mask) -> some View {
        self.mask(
            ZStack(alignment: alignment) {
                Rectangle()
                
                mask()
                    .blendMode(.destinationOut)
            }
        )
    }
}
