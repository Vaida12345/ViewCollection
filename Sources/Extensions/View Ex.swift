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
    
    // MARK: - Picker with String
    /// Initialize a picker with its `options`.
    ///
    /// - Parameters:
    ///   - title: A localized string key that describes the purpose of selecting an option.
    ///   - selection: A binding to a property that determines the currently-selected option.
    ///   - options: A set of options that builds a `ForEach` view.
    @available(*, deprecated, message: "Please make sure that `SelectionValue` conforms to `CustomLocalizedStringResourceConvertible`.")
    @inlinable
    init(_ title: LocalizedStringKey = "", selection: Binding<SelectionValue>, options: [SelectionValue]) where SelectionValue: CustomStringConvertible, Label == Text, Content == ForEach<[SelectionValue], SelectionValue, Text> {
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
    @available(*, deprecated, message: "Please make sure that `SelectionValue` conforms to `CustomLocalizedStringResourceConvertible`.")
    @inlinable
    init(_ title: LocalizedStringKey = "", selection: Binding<SelectionValue>, options: [SelectionValue]) where SelectionValue: RawRepresentable, Label == Text, Content == ForEach<[SelectionValue], SelectionValue, Text> {
        self.init(title, selection: selection) {
            ForEach(options, id: \.self) {
                Text("\($0)")
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
    @available(*, deprecated, message: "Please make sure that `SelectionValue` conforms to `CustomLocalizedStringResourceConvertible`.")
    @inlinable
    init(_ title: LocalizedStringKey = "", selection: Binding<SelectionValue>) where SelectionValue: RawRepresentable, SelectionValue: CaseIterable, Label == Text, Content == ForEach<SelectionValue.AllCases, SelectionValue, Text> {
        self.init(title, selection: selection) {
            ForEach(SelectionValue.allCases, id: \.self) {
                Text("\($0)")
            }
        }
    }
    
    // MARK: - Picker with Localized String
    /// Initialize a picker with its `options`.
    ///
    /// - Parameters:
    ///   - title: A localized string key that describes the purpose of selecting an option.
    ///   - selection: A binding to a property that determines the currently-selected option.
    ///   - options: A set of options that builds a `ForEach` view.
    @inlinable
    init(_ title: LocalizedStringKey = "", selection: Binding<SelectionValue>, options: [SelectionValue]) where SelectionValue: CustomLocalizedStringResourceConvertible, Label == Text, Content == ForEach<[SelectionValue], SelectionValue, Text> {
        self.init(title, selection: selection) {
            ForEach(options, id: \.self) {
                Text($0.localizedStringResource)
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
    init(_ title: LocalizedStringKey = "", selection: Binding<SelectionValue>) where SelectionValue: CustomLocalizedStringResourceConvertible, SelectionValue: CaseIterable, Label == Text, Content == ForEach<SelectionValue.AllCases, SelectionValue, Text> {
        self.init(title, selection: selection) {
            ForEach(SelectionValue.allCases, id: \.self) {
                Text($0.localizedStringResource)
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


extension View {
    
    /// Calls `action(date)` every `interval` seconds for as long as this view is in the hierarchy.
    public func onTimer(
        every interval: Duration,
        tolerance: TimeInterval? = nil,
        scheduler: RunLoop = .main,
        in runLoopMode: RunLoop.Mode = .common,
        perform action: @escaping (Date) -> Void
    ) -> some View {
        // create a Timer publisher that emits a Date every `interval` seconds …
        let publisher = Timer
            .publish(every: interval.seconds, tolerance: tolerance, on: scheduler, in: runLoopMode)
            .autoconnect()
        
        // … and hook it up to this view
        return self.onReceive(publisher) { date in
            action(date)
        }
    }
    
}
