//
//  UndoViews.swift
//  ViewCollection
//
//  Created by Vaida on 2026-05-29.
//

import SwiftUI


/// A undo button.
///
/// ```swift
/// @State var observer = UndoObserver(undoManager: nil)
///
/// HStack {
///     UndoButton(observer: observer)
///     RedoButton(observer: observer)
/// }
/// .undoObservation($observer)
/// ```
public struct UndoButton: View {
    
    private let observer: UndoObserver
    
    public var body: some View {
        Button {
            observer.undo()
        } label: {
            Label(observer.undoLabel, systemImage: "arrow.uturn.backward")
        }
        .keyboardShortcut("z")
        .disabled(!observer.canUndo)
    }
    
    public init(observer: UndoObserver) {
        self.observer = observer
    }
}


/// A redo button.
///
/// ```swift
/// @State var observer = UndoObserver(undoManager: nil)
///
/// HStack {
///     UndoButton(observer: observer)
///     RedoButton(observer: observer)
/// }
/// .undoObservation($observer)
/// ```
public struct RedoButton: View {
    
    private let observer: UndoObserver
    
    public var body: some View {
        Button {
            observer.redo()
        } label: {
            Label(observer.redoLabel, systemImage: "arrow.uturn.forward")
        }
        .keyboardShortcut("z", modifiers: [.command, .shift])
        .disabled(!observer.canRedo)
    }
    
    public init(observer: UndoObserver) {
        self.observer = observer
    }
}


private struct UndoObservationModifier: ViewModifier {
    
    let observer: Binding<UndoObserver>
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                observer.wrappedValue.addObserver()
            }
            .onDisappear {
                observer.wrappedValue.removeObserver()
            }
    }
}


extension View {
    
    /// Observes undo / redo state and updates `observer`.
    ///
    /// - Important: Create only one observer per `UndoManager`, otherwise it may cause conflicts.
    ///
    /// ```swift
    /// @State var observer = UndoObserver(undoManager: nil)
    ///
    /// HStack {
    ///     UndoButton(observer: observer)
    ///     RedoButton(observer: observer)
    /// }
    /// .undoObservation($observer)
    /// ```
    public func undoObservation(_ observer: Binding<UndoObserver>) -> some View {
        self.modifier(UndoObservationModifier(observer: observer))
    }
    
}


#Preview {
    @Previewable @State var observer = UndoObserver(undoManager: nil)
    
    HStack {
        UndoButton(observer: observer)
        RedoButton(observer: observer)
    }
    .undoObservation($observer)
}
