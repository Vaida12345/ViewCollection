//
//  UndoObserverTests.swift
//  ViewCollection
//
//  Created by Vaida on 2026-05-29.
//

import Testing
@testable import ViewCollection
import Foundation


@MainActor
@Suite("UndoObserver")
struct UndoObserverTests {

    // MARK: - Initialization

    @Test("init with nil UndoManager sets defaults")
    func initNilManager() {
        let observer = UndoObserver(undoManager: nil)

        #expect(observer.canUndo == false)
        #expect(observer.canRedo == false)
        #expect(observer.undoLabel == "Undo")
        #expect(observer.redoLabel == "Redo")
    }

    @Test("init with fresh UndoManager reflects no undo/redo available")
    func initFreshManager() {
        let manager = UndoManager()
        let observer = UndoObserver(undoManager: manager)

        #expect(observer.canUndo == false)
        #expect(observer.canRedo == false)
        #expect(observer.undoLabel == "Undo")
        #expect(observer.redoLabel == "Redo")
    }

    @Test("init with manager that has undo actions reflects canUndo")
    func initWithUndoActions() {
        let manager = UndoManager()
        let model = Model()
        manager.setActionName("Increment")
        model.increment(undoManager: manager)

        let observer = UndoObserver(undoManager: manager)

        #expect(observer.canUndo == true)
        #expect(observer.undoLabel == "Undo Increment")
    }

    @Test("init with manager that has redo actions reflects canRedo")
    func initWithRedoActions() throws {
        let manager = UndoManager()
        let model = Model()
        manager.setActionName("Increment")
        model.increment(undoManager: manager)
        manager.undo()
        
        try #require(manager.canRedo)
        try #require(model.value == 0)
        try #require(manager.redoMenuItemTitle == "Redo Increment")

        let observer = UndoObserver(undoManager: manager)

        #expect(observer.canRedo == true)
        #expect(observer.redoLabel == "Redo Increment")
    }

    // MARK: - undo()

    @Test("undo calls undoManager.undo")
    func undoDelegatesToManager() throws {
        let manager = UndoManager()
        let model = Model()
        manager.setActionName("Increment")
        model.increment(undoManager: manager)
        
        #expect(manager.canUndo == true)
        try #require(model.value == 1)

        let observer = UndoObserver(undoManager: manager)
        observer.undo()

        #expect(manager.canUndo == false)
        try #require(model.value == 0)
    }

    @Test("undo with nil manager is safe")
    func undoNilManager() {
        let observer = UndoObserver(undoManager: nil)
        observer.undo()
    }

    @Test("undo when there is nothing to undo is safe")
    func undoWhenNothingToUndo() throws {
        let manager = UndoManager()
        try #require(manager.canUndo == false)

        let observer = UndoObserver(undoManager: manager)
        observer.undo()

        #expect(manager.canUndo == false)
    }

    // MARK: - redo()

    @Test("redo calls undoManager.redo")
    func redoDelegatesToManager() throws {
        let manager = UndoManager()
        let model = Model()
        manager.setActionName("Increment")
        model.increment(undoManager: manager)
        manager.undo()
        try #require(manager.canRedo == true)

        let observer = UndoObserver(undoManager: manager)
        observer.redo()

        #expect(manager.canRedo == false)
    }

    @Test("redo with nil manager is safe")
    func redoNilManager() {
        let observer = UndoObserver(undoManager: nil)
        observer.redo()
    }

    @Test("redo when there is nothing to redo is safe")
    func redoWhenNothingToRedo() {
        let manager = UndoManager()
        #expect(manager.canRedo == false)

        let observer = UndoObserver(undoManager: manager)
        observer.redo()

        #expect(manager.canRedo == false)
    }

    // MARK: - Multiple actions

    @Test("tracks multiple undo levels correctly")
    func multipleUndoLevels() throws {
        let manager = UndoManager()
        let model = Model()
        manager.groupsByEvent = false
        
        // undoManager groups events together in the same run loop by default, so needs explicit grouping.
        manager.beginUndoGrouping()
        manager.setActionName("Increment 1")
        model.increment(undoManager: manager)
        manager.endUndoGrouping()
        
        manager.beginUndoGrouping()
        try #require(manager.canUndo == true)
        manager.setActionName("Increment 2")
        model.increment(undoManager: manager)
        try #require(manager.canUndo == true)
        manager.endUndoGrouping()

        let observer = UndoObserver(undoManager: manager)
        observer.addObserver()

        try #require(manager.undoMenuItemTitle == "Undo Increment 2")
        #expect(observer.undoLabel == "Undo Increment 2")
        print("undo increment 2")
        observer.undo()
        print("query canUndo")
        try #require(manager.canUndo == true)
        #expect(observer.canUndo == true)

        print("query undoMenuItemTitle")
        try #require(manager.undoMenuItemTitle == "Undo Increment 1")
        #expect(observer.undoLabel == "Undo Increment 1")
        print("undo increment 1")
        observer.undo()
        try #require(manager.canUndo == false)
        #expect(observer.canUndo == false)
    }

    @Test("undo then redo roundtrip")
    func undoRedoRoundtrip() {
        let manager = UndoManager()
        let model = Model()
        manager.setActionName("Increment")
        model.increment(undoManager: manager)
        
        let observer = UndoObserver(undoManager: manager)
        observer.addObserver()
        
        #expect(observer.canUndo == true)
        #expect(observer.canRedo == false)

        observer.undo()
        #expect(observer.canUndo == false)
        #expect(observer.canRedo == true)

        observer.redo()
        #expect(observer.canUndo == true)
        #expect(observer.canRedo == false)
    }

    // MARK: - Label tracking

    @Test("undoLabel reflects most recent undo action name")
    func undoLabelTracksActionName() {
        let manager = UndoManager()
        let model = Model()
        manager.setActionName("Increment")
        model.increment(undoManager: manager)

        let observer = UndoObserver(undoManager: manager)
        observer.addObserver()
        
        #expect(observer.undoLabel == "Undo Increment")
    }

    @Test("redoLabel reflects most recent redo action name")
    func redoLabelTracksActionName() {
        let manager = UndoManager()
        let model = Model()
        manager.setActionName("Increment")
        model.increment(undoManager: manager)
        
        let observer = UndoObserver(undoManager: manager)
        observer.addObserver()
        
        manager.undo()

        #expect(observer.redoLabel == "Redo Increment")
    }
}


@MainActor
final class Model {
    
    var value: Int = 0
    
    func increment(undoManager: UndoManager?) {
        value += 1
        
        undoManager?.registerUndo(withTarget: self) { [weak undoManager] in
            $0.decrement(undoManager: undoManager)
        }
    }
    
    func decrement(undoManager: UndoManager?) {
        value -= 1
        
        undoManager?.registerUndo(withTarget: self) { [weak undoManager] in
            $0.increment(undoManager: undoManager)
        }
    }
}
