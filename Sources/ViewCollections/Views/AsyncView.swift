//
//  AsyncView.swift
//  The Stratum Module
//
//  Created by Vaida on 5/1/22.
//  Copyright © 2019 - 2024 Vaida. All rights reserved.
//


import SwiftUI
import Stratum


/// An async view that only presents the content if the content is loaded.
///
/// > Example:
/// >
/// > Present the value on completion of `await`ed result generator.
/// >
/// > ```swift
/// > AsyncView {
/// >     // value: () async throws -> String
/// > } content: { result in
/// >     Text(result)
/// > }
/// > ```
///
/// - Tip: Open an unstructured `Task` only when something makes sense to execute *concurrently* to the `View`'s normal operation, like refreshing the model, not `buttonTapped()` callbacks.
public struct AsyncView<Success, Captures, Content: View, PlaceHolder: View>: View where Success: Sendable, Captures: Sendable & Equatable {
    
    private let captures: Captures
    private let resultGenerator: @Sendable (Captures) async throws -> Success?
    private let viewGenerator: (_ result: Success) -> Content
    private let placeHolder: () -> PlaceHolder
    
    @State private var result: Success?
    
    public var body: some View {
        Group {
            if let result = result {
                viewGenerator(result)
            } else {
                Group {
                    let placeHolder = placeHolder()
                    if !(placeHolder is EmptyView) {
                        placeHolder
                    } else {
                        Rectangle()
                            .frame(width: 0, height: 0) // do not change to empty view. Must be here for `task` to work.
                    }
                }
                .task {
                    await self.update(captures: self.captures)
                }
            }
        }
        .onChange(of: captures) { newValue in
            Task { @MainActor in
                await self.update(captures: newValue)
            }
        }
    }
    
    /// Initialize the `AsyncView`.
    ///
    /// The result generator is a sendable closure to lift the work out of `@MainActor`. Hence there should not exits any UI updates within the `result` closure.
    ///
    /// - Important: Do not attempt to auto capture, pass arguments using `capture` instead.
    ///
    /// - Parameters:
    ///   - captures: The captured contents that will be passed to `result`. Please do not use auto capture within that closure.
    ///   - result: The closure that would typically take time to generate the result.
    ///   - content: The `View` that makes use of the result generated. It would only be presented when the results has been generated asynchronously.
    ///   - placeHolder: The temperate view shown when the result is still be generated.
    public init(captures: Captures,
                result: @escaping @Sendable (_ captures: Captures) async throws -> Success?,
                @ViewBuilder content: @escaping (_ result: Success) -> Content,
                @ViewBuilder placeHolder: @escaping () -> PlaceHolder = { EmptyView() }) {
        self.captures = captures
        self.resultGenerator = result
        self.viewGenerator = content
        self.placeHolder = placeHolder
    }
    
    func update(captures: Captures) async {
        nonisolated(unsafe)
        let captures = captures
        nonisolated(unsafe)
        let resultGenerator = resultGenerator
        nonisolated(unsafe)
        let success = await _updates(captures, resultGenerator: resultGenerator)
        await MainActor.run {
            self.result = success
        }
    }
    
}

nonisolated
private func _updates<Captures, Success>(_ captures: Captures, resultGenerator: @Sendable (Captures) async throws -> Success?) async -> Success? {
    do {
        return try await resultGenerator(captures)
    } catch is CancellationError {
        return nil
    } catch {
        AlertManager(error).present()
    }
    return nil
}


private struct AsyncViewPreview: View {
    
    @State private var state = 0.0
    
    var body: some View {
        VStack {
            AsyncView(captures: state) { state in
                state
            } content: { result in
                Text("\(result)")
            }
            
            Text("\(state)")
            
            Slider(value: $state)
        }
    }
}


#Preview {
    AsyncViewPreview()
        .padding(.all)
        .frame(width: 400, height: 200)
}
