//
//  AsyncView.swift
//  The Stratum Module
//
//  Created by Vaida on 5/1/22.
//  Copyright © 2019 - 2024 Vaida. All rights reserved.
//

import SwiftUI
import NativeImage
import Essentials


/// An async view that only presents the content if the content is loaded.
///
/// > Example:
/// >
/// > Present the value on completion of `await`ed result generator.
/// >
/// > ```swift
/// > AsyncView(generator: fetchData) { result in
/// >     Text(result)
/// > }
/// > ```
///
/// ## Fetch Data
///
/// For the first closure, `generator`, you **need** to pass *only* a `nonisolated` method. Then, give the view an `id` to track changes.
///
///
/// ## Dealing with states
///
/// A typical use of this view is to create a `@State` based on the result of `generator`. However, SwiftUI would not like that. A workaround would be adding an `id` to the `AsyncView` with the identifier as an indication that the `View` should be reset.
///
/// ```swift
/// AsyncView(generator: fetchData) { results, data in
///     ParagraphView(results: results, receivedData: receivedData, data: data)
/// }
/// .id(receivedData.id)
/// ```
///
/// In this example, `data` is passed to `ParagraphView` as an `@State` property. Such property is reset when the `receivedData.id` changes.
///
/// The `state`'s initial value can only be set once; there after, setting it in init has not effect, which is why an `id(_:)` is required.
///
/// - experiment: For some reason, however, the `data` is linked with the `id`, meaning that the `data` is preserved for each `id`.
///
/// - Tip: If you would like to async generate and render a `CGImage`, please use ``AsyncDrawnImage`` instead.
///
/// - Tip: Open an unstructured `Task` only when something makes sense to execute *concurrently* to the `View`'s normal operation, like refreshing the model, not `buttonTapped()` callbacks.
public struct AsyncView<Success, Content: View, PlaceHolder: View>: View where Success: Sendable {
    
    private let resultGenerator: @Sendable () async throws -> Success?
    private let viewGenerator: (_ result: Success) -> Content
    private let placeHolder: () -> PlaceHolder
    
    @State private var result: Success?
    
    public var body: some View {
        Group {
            if let result {
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
                    await self.update()
                }
            }
        }
    }
    
    /// Initialize the `AsyncView`.
    ///
    /// The result generator is a sendable closure to lift the work out of `@MainActor`. Hence there should not exits any UI updates within the `result` closure.
    ///
    /// - Important: Do not attempt to auto capture, pass arguments to another `nonisolated` method and pass to the `generator` again.
    ///
    /// - Parameters:
    ///   - generator: The closure that would typically take time to generate the result.
    ///   - content: The `View` that makes use of the result generated. It would only be presented when the results has been generated asynchronously.
    ///   - placeHolder: The temperate view shown when the result is still be generated.
    public init(generator: @escaping @Sendable () async throws -> Success?,
                @ViewBuilder content: @escaping (_ result: Success) -> Content,
                @ViewBuilder placeHolder: @escaping () -> PlaceHolder = { EmptyView() }) {
        self.resultGenerator = generator
        self.viewGenerator = content
        self.placeHolder = placeHolder
    }
    
    func update() async {
        let resultGenerator = resultGenerator
        let success = await _updates(resultGenerator: resultGenerator)
        
        await MainActor.run {
            withAnimation {
                self.result = success
            }
        }
    }
    
}

nonisolated
private func _updates<Success>(resultGenerator: @Sendable () async throws -> Success?) async -> Success? {
    let result = await withErrorPresented("Failed to update view state") { () -> Success? in
        do {
            return try await resultGenerator()
        } catch is CancellationError {
            return nil
        } catch {
            throw error
        }
    }
    return result?.flatMap(\.self)
}


private struct AsyncViewPreview: View {
    
    @State private var state = 0.0
    
    var body: some View {
        VStack {
            AsyncView {
                await state
            } content: { result in
                Text("\(result)")
            }
            .id(state)
            
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
