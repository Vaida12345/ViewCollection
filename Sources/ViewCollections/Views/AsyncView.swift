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
/// ## Dealing with states
///
/// A typical use of this view is to create a `@State` based on the result of `resultGenerator`. However, SwiftUI would not like that. A workaround would be adding an `id` to the `AsyncView` with the identifier as an indication that the `View` should be reset.
///
/// ```swift
/// AsyncView {
///     try fetchData()
/// } content: { results, data in
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
/// - note: Open an unstructured `Task` only when something makes sense to execute *concurrently* to the `View`'s normal operation, like refreshing the model, not `buttonTapped()` callbacks.
///
/// - Tip: Initialize the `_state` using `State.init(wrappedValue:)`.
///
/// > Note:
/// > It is also possible to pass an `@Observable` object. Declare the `data` as a constant in the child view, then inside the `body`, declare:
/// > ```swift
/// > @Bindable var data = data
/// > ```
public struct AsyncView<Success, Content: View, PlaceHolder: View>: View where Success: Sendable {
    
    private let resultGenerator: @Sendable () async throws -> Success?
    private let viewGenerator: (_ result: Success) -> Content
    private let placeHolder: () -> PlaceHolder
    private let id: Int
    
    public var body: some View {
        BodyView(resultGenerator: resultGenerator, viewGenerator: viewGenerator, placeHolder: placeHolder, id: id)
            .id(id)
    }
    
    /// Initialize the `AsyncView`.
    ///
    /// The result generator is a sendable closure to lift the work out of `@MainActor`. Hence, any update to UI should be called using `@MainActor Task`.
    ///
    /// - Important: Please do not pass `EmptyView` as placeholder, otherwise `.task` would not be trigged.
    ///
    /// - Parameters:
    ///   - result: The closure that would typically take time to generate the result.
    ///   - content: The `View` that makes use of the result generated. It would only be presented when the results has been generated asynchronously.
    ///   - placeHolder: The temperate view shown when the result is still be generated.
    public init(result: @escaping @Sendable () async throws -> Success?, 
                @ViewBuilder content: @escaping (_ result: Success) -> Content,
                @ViewBuilder placeHolder: @escaping () -> PlaceHolder = { EmptyView() },
                id: Int = 0) {
        self.resultGenerator = result
        self.viewGenerator = content
        self.placeHolder = placeHolder
        self.id = id
    }
    
    
    public func id(_ id: some Hashable) -> AsyncView {
        AsyncView(result: resultGenerator, content: viewGenerator, placeHolder: placeHolder, id: id.hashValue)
    }
    
    
    private struct BodyView: View {
        
        let resultGenerator: @Sendable () async throws -> Success?
        let viewGenerator: (_ result: Success) -> Content
        let placeHolder: () -> PlaceHolder
        let id: Int
        
        @State private var result: Success?
        
        
        var body: some View {
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
                        do {
                            let result = try await resultGenerator()
                            await MainActor.run {
                                self.result = result
                            }
                        } catch {
                            AlertManager(error).present()
                        }
                    }
                }
            }
            .onChange(of: id) { _ in
                Task {
                    do {
                        let result = try await resultGenerator()
                        await MainActor.run {
                            self.result = result
                            print("update")
                        }
                    } catch {
                        AlertManager(error).present()
                    }
                }
            }
        }
    }
    
}
