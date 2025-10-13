//
//  DropHandlerView.swift
//  The Stratum Module
//
//  Created by Vaida on 1/18/23.
//  Copyright © 2019 - 2024 Vaida. All rights reserved.
//


#if !os(watchOS) && !os(tvOS)
import SwiftUI
import UniformTypeIdentifiers
import FinderItem
import Essentials


/// A view that handles drops from Finder.
///
/// - Warning: The operating system implicitly starts security-scoped access on `URL`s passed. When you’ve finished with the resources, call `stopAccessingSecurityScopedResource()` to revoke your app’s access.
///
/// ## Creating Instances
///
/// The drop handler view can be created by providing the optional prompt.
/// ```swift
/// DropHandlerView()
/// ```
///
/// To make the drop action work, the ``DropHandlerView/onDrop(_:)`` needs to be filled.
/// ```swift
/// DropHandlerView()
///     .onDrop { sources in
///         // handle the dropped finder items.
///     }
/// ```
///
/// > Tip: In `ForEach`, you can use `dropDestination` instead.
/// >
/// > ```swift
/// > .dropDestination(for: FinderItem.self) { sources, _ in
/// >     withErrorPresented("Failed to import") {
/// >         for source in sources {
/// >             try self.load(from: source)
/// >         }
/// >     }
/// > }
/// > ```
public struct DropHandlerView<Overlay>: View where Overlay: View {
    
    // MARK: - Basic Properties
    
    /// The text shown as a prompt.
    private let prompt: LocalizedStringKey
    
    /// The alignment of the overlay.
    private let overlayAlignment: Alignment
    
    /// A boolean value determining whether the overlay is shown.
    private let isOverlayHidden: Bool
    
    
    /// The handler with an array of the `FinderItems` to the path of the *dropped* items.
    private let dropHandler: @Sendable (_ sources: [FinderItem]) throws -> Void
    
    /// Layers the views that you specify in front of this view and hides the prompt.
    private let overlay: (_ isTargeted: Bool) -> Overlay
    
    /// Whether should allow file importer and allow multiple selection.
    private let allowMultipleSelection: Bool?
    
    /// Whether a file has entered the drop area.
    @State private var isDropTargeted = false
    
    @State private var showFileImporter = false
    
    
    @Environment(\.isEnabled) private var isEnabled
    
    
    // MARK: - Instance Properties
    
    @ViewBuilder
    private var promptView: some View {
        if self.isOverlayHidden {
            if allowMultipleSelection != nil {
                Button {
                    showFileImporter = true
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.secondary.opacity(0.1))
                            .padding(.all, 1)
                        
                        Image(systemName: "plus")
                        
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: isDropTargeted ? 2 : 0)
                            .foregroundColor(Color.accentColor)
                            .padding(.all, 1)
                    }
                }
                .buttonStyle(.plain)
                .contentShape(Rectangle())
            } else {
                VStack {
                    Image(systemName: "square.and.arrow.down")
                        .resizable()
                        .scaledToFit()
                        .padding()
                        .frame(width: 150, height: 150, alignment: .center)
                        .fontWeight(.light)
                        .foregroundStyle(isDropTargeted ? .blue : .secondary)
                    
                    Text(prompt, bundle: .module)
                        .bold()
                        .fontDesign(.rounded)
                        .font(.title3)
                }
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        } else {
            self.overlay(isDropTargeted)
        }
    }
    
    /// The main body.
    public var body: some View {
        if isEnabled {
            promptView
                .dropDestination(for: FinderItem.self) { items, location in
                    withErrorPresented("Failed to import items") {
                        try self.dropHandler(items)
                        return true
                    } ?? false
                } isTargeted: { isTargeted in
                    withAnimation(.spring().speed(4)) {
                        self.isDropTargeted = isTargeted
                    }
                }
                .fileImporter(isPresented: $showFileImporter, allowedContentTypes: [.fileURL], allowsMultipleSelection: allowMultipleSelection ?? false) { result in
                    withErrorPresented("Failed to import items") {
                        let urls = try result.get()
                        try dropHandler(urls.map({ FinderItem(at: $0) }))
                    }
                }
        } else {
            promptView
        }
    }
    
    
    // MARK: - Instance Methods
    
    /// Defines the destination for a drag and drop operation, handling dropped content with the given closure.
    ///
    /// The handler is isolated `Sendable` to move from `MainActor` to a background `Task`, any modifications to UI should be reported using `@MainActor`.
    ///
    /// ```swift
    /// DropHandlerView()
    ///     .onDrop { sources in
    ///         let items = await operation(sources)
    ///         await MainActor.run {
    ///             self.items = items
    ///         }
    ///     }
    /// ```
    ///
    /// > Warning:
    /// > The sources are security-scoped, which means you need to manually start and stop the security scope using `tryAccessSecurityScope` and `stopAccessSecurityScope`.
    /// >
    /// > ```swift
    /// > .onDrop { sources in
    /// >     try? sources.tryAccessSecurityScope()
    /// >
    /// >     Task { @MainActor in
    /// >         defer { sources.stopAccessSecurityScope() }
    /// >         do {
    /// >             let newItems = try await loadItems(from: sources)
    /// >         } catch {
    /// >             AlertManager(error).present()
    /// >         }
    /// >     }
    /// > }
    /// > ```
    /// >
    /// > You should use `try?` to avoid the access being already provided.
    ///
    /// - note: This method can only handle drops from finders.
    ///
    /// - Parameters:
    ///   - handler: The handler with an array of the `FinderItems` to the path of the *dropped* items.
    public func onDrop(_ handler: @escaping @Sendable (_ sources: [FinderItem]) throws -> Void) -> DropHandlerView {
        DropHandlerView(prompt: self.prompt,
                        overlayAlignment: self.overlayAlignment,
                        isOverlayHidden: self.isOverlayHidden,
                        allowMultipleSelection: self.allowMultipleSelection,
                        overlay: self.overlay,
                        dropHandler: handler
        )
    }
    
    /// Layers the views that you specify in front of this view and hides the prompt.
    ///
    /// This method is used instead of `if`-clause to insure the drop works properly when the `prompt` is hidden.
    ///
    /// - Note: The `isDropTargeted` is used to update UI when an item has entered drop area.
    ///
    /// - Parameters:
    ///   - alignment: The alignment that the modifier uses to position the implicit `ZStack` that groups the foreground views. The default is `center`.
    ///   - hidden: A boolean value indicating whether the overlay is hidden. (And the prompt is shown).
    ///   - content: A ViewBuilder that you use to declare the views to draw in front of this view, stacked in the order that you list them. The last view that you list appears at the front of the stack.
    public func overlay<Content: View>(alignment: Alignment = .center,
                                       hidden: Bool = false,
                                       @ViewBuilder content: @escaping (_ isDropTargeted: Bool) -> Content
    ) -> DropHandlerView<Content> {
        DropHandlerView<Content>(prompt: self.prompt,
                                 overlayAlignment: alignment,
                                 isOverlayHidden: hidden,
                                 allowMultipleSelection: self.allowMultipleSelection,
                                 overlay: content,
                                 dropHandler: self.dropHandler
        )
    }
    
    /// Determines whether a plus button should be shown to show file importer on tap.
    ///
    /// - Parameters:
    ///   - allowMultipleSelection: Whether the importer allows the user to select more than one file to import.
    public func showFileImporterBox(allowMultipleSelection: Bool = false) -> DropHandlerView {
        DropHandlerView(prompt: self.prompt,
                        overlayAlignment: self.overlayAlignment,
                        isOverlayHidden: self.isOverlayHidden,
                        allowMultipleSelection: allowMultipleSelection,
                        overlay: self.overlay,
                        dropHandler: self.dropHandler
        )
    }
    
    
    // MARK: - Designated Initializers
    
    /// Initialize a drop handler.
    private init(prompt: LocalizedStringKey,
                 overlayAlignment: Alignment,
                 isOverlayHidden: Bool,
                 allowMultipleSelection: Bool?,
                 overlay: @escaping (_ isDropTargeted: Bool) -> Overlay,
                 dropHandler: @Sendable @escaping (_: [FinderItem]) throws -> Void
    ) {
        
        self.prompt = prompt
        self.overlayAlignment = overlayAlignment
        self.allowMultipleSelection = allowMultipleSelection
        
        self.dropHandler = dropHandler
        self.overlay = overlay
        self.isOverlayHidden = isOverlayHidden
    }
    
    
    // MARK: - Initializers
    
    /// Creates a drop handler view.
    ///
    /// You would need to handle the drop using ``onDrop(_:)``.
    ///
    /// - Parameters:
    ///   - prompt: The text shown as a prompt.
    public init(prompt: LocalizedStringKey = "Drag in files or folder") where Overlay == EmptyView {
        self.init(prompt: prompt,
                  overlayAlignment: .center,
                  isOverlayHidden: true,
                  allowMultipleSelection: nil,
                  overlay: { _ in EmptyView() },
                  dropHandler: { _ in }
        )
    }
    
}

#Preview {
    DropHandlerView()
}

#endif
