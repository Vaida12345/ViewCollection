//
//  UndoObserver.swift
//  ViewCollection
//
//  Created by Vaida on 2026-05-29.
//

import Foundation
import Observation


/// An observer to a given `UndoManager`.
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
@MainActor
@Observable
public final class UndoObserver {
    
    @ObservationIgnored
    private var undoChangeObserver: (any NSObjectProtocol)? = nil
    
    public private(set) var canUndo: Bool
    public private(set) var canRedo: Bool
    public private(set) var undoLabel: String
    public private(set) var redoLabel: String
    
    private let undoManager: UndoManager?
    
    public func undo() { self.undoManager?.undo() }
    public func redo() { self.undoManager?.redo() }
    
    
    /// Initialize an observer.
    ///
    /// - Important: To ensure it can be quickly constructed and discarded in `SwiftUI` views, this does not start the observer. Use ``View/undoObservation``.
    public init(undoManager: UndoManager?) {
        self.canUndo = undoManager?.canUndo ?? false
        self.canRedo = undoManager?.canRedo ?? false
        self.undoLabel = undoManager?.undoMenuItemTitle ?? LocalizedStringResource("Undo", bundle: .module).localized()
        self.redoLabel = undoManager?.redoMenuItemTitle ?? LocalizedStringResource("Redo", bundle: .module).localized()
        
        self.undoManager = undoManager
    }
    
    func addObserver() {
        guard undoChangeObserver == nil else { return } // already added
        
        guard let undoManager else { return }
        self.undoChangeObserver = NotificationCenter.default.addObserver(
            forName: .NSUndoManagerCheckpoint,
            object: undoManager,
            queue: nil) { [weak self] notification in
                guard !UndoObserverIsQueryingUndoManager else { return } // invoked during query, ignore.
                // `NSUndoManagerCheckpoint` is called even when querying `canUndo`.
                // however, this works as, and I quote,
                //
                // When `queue` is nil, the block runs synchronously on the posting thread.
                // The system posts this notification (NSUndoManagerCheckpoint) on the actor, thread, or dispatch queue that calls beginUndoGrouping(), endUndoGrouping(), or canRedo.
                //
                // hence when querying undo, it is ran on the same thread as the task local value, evoking this observer closure again, but exist as soon as it enters.
                
                guard let undoManager = notification.object as? UndoManager else { return }
                
                $UndoObserverIsQueryingUndoManager.withValue(true) {
                    // must run without MainActor isolation, as TaskLocal value depends on this (non) isolation.
                    let canUndo = undoManager.canUndo
                    let canRedo = undoManager.canRedo
                    let undoLabel = undoManager.undoMenuItemTitle
                    let redoLabel = undoManager.redoMenuItemTitle
                    
                    self?.canUndo = canUndo
                    self?.canRedo = canRedo
                    self?.undoLabel = undoLabel
                    self?.redoLabel = redoLabel
                }
            }
    }
    
    func removeObserver() {
        if let undoChangeObserver {
            NotificationCenter.default.removeObserver(undoChangeObserver)
            self.undoChangeObserver = nil
        }
    }
}

// must declare here, otherwise it got bounded to MainActor.
@TaskLocal private var UndoObserverIsQueryingUndoManager: Bool = false
