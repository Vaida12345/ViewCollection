//
//  StateView.swift
//  The Stratum Module
//
//  Created by Vaida on 2024/3/6.
//  Copyright © 2019 - 2024 Vaida. All rights reserved.
//


import Foundation
import SwiftUI


private struct StateView<Value, ContentView: View>: View {
    
    @State var value: Value
    
    let handler: (_ state: Binding<Value>) -> ContentView
    
    var body: some View {
        handler($value)
    }
    
}


/// Creates a new `view` hierarchy, with the only state being the one set with `initialValue`.
///
/// > Example:
/// > You can use this function in any View, or in `#Preview`:
/// > ```swift
/// > #Preview {
/// >     withStateObserved(initial: false) { state in
/// >         Toggle("Hit me!", isOn: state)
/// >     }
/// > }
/// > ```
/// > In the preview, the state is observed and mutable.
///
/// > Tip: With Swift6.0, you can use `@Previewable` to achieve this.
/// > ```swift
/// > #Preview {
/// >   @Previewable @State var state = false
/// >   Toggle("Hit me!", isOn: state)
/// > }
/// > ```
///
/// - Parameters:
///   - initialValue: The initial value of the state.
///   - handler: The view builder.
@MainActor 
public func withStateObserved<Value: Hashable>(initial initialValue: Value, @ViewBuilder handler: @escaping (_ state: Binding<Value>) -> some View) -> some View {
    StateView(value: initialValue, handler: handler)
        .id(initialValue)
}


#Preview {
    withStateObserved(initial: 0.0) { state in
        Text("\(state.wrappedValue)")
        Slider(value: state)
    }
}
