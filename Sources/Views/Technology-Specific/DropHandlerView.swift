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
/// - Warning: Security-scoped access depends on where the items come from:
///   - Dropped items: The operating system implicitly starts security-scoped access on the `URL`s passed. When you’ve finished with the resources, call `stopAccessingSecurityScopedResource()` to revoke your app’s access.
///   - Items chosen in the file importer (see ``showFileImporterBox(allowMultipleSelection:)``): Access isn’t started for you. Call `startAccessingSecurityScopedResource()` before using the resources, and `stopAccessingSecurityScopedResource()` when you’ve finished with them.
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
    private let prompt: LocalizedStringResource
    
    /// The alignment of the overlay.
    private let overlayAlignment: Alignment
    
    /// A boolean value determining whether the overlay is shown.
    private let isOverlayHidden: Bool
    
    
    /// The handler with an array of the `FinderItems` to the path of the *dropped* items.
    private let dropHandler: @MainActor (_ sources: [FinderItem]) throws -> Void
    
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
                            .foregroundStyle(Color.accentColor)
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
                    
                    Text(prompt)
                        .bold()
                        .fontDesign(.rounded)
                        .font(.title3)
                }
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        } else {
            self.overlay(isDropTargeted)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: overlayAlignment)
        }
    }
    
    /// The main body.
    public var body: some View {
        promptView
            .dropDestination(for: FinderItem.self) { items, location in
                guard isEnabled else { return false }
                return withErrorPresented("Failed to import items") {
                    try self.dropHandler(items)
                    return true
                } ?? false
            } isTargeted: { isTargeted in
                let isTargeted = isEnabled && isTargeted
                guard isTargeted != self.isDropTargeted else { return }
                withAnimation(.spring().speed(4)) {
                    self.isDropTargeted = isTargeted
                }
            }
            .fileImporter(isPresented: $showFileImporter, allowedContentTypes: [.fileURL], allowsMultipleSelection: allowMultipleSelection ?? false) { result in
                guard isEnabled else { return }
                withErrorPresented("Failed to import items") {
                    let urls = try result.get()
                    try dropHandler(urls.map({ FinderItem(at: $0) }))
                }
            }
    }
    
    
    // MARK: - Instance Methods
    
    /// Defines the destination for a drag and drop operation, handling dropped content with the given closure.
    ///
    /// The handler is called synchronously on the main actor, so you can update your view’s state directly. To perform asynchronous work, start a `Task` from the handler.
    ///
    /// ```swift
    /// DropHandlerView()
    ///     .onDrop { sources in
    ///         self.items.append(contentsOf: sources)
    ///     }
    /// ```
    ///
    /// Errors thrown from the handler are presented to the user, and the drop is reported as failed.
    ///
    /// > Warning:
    /// > The sources are security-scoped. For dropped items, the operating system has already started access; for items chosen in the file importer, it hasn’t. Since the handler receives both, start the security scope using `tryAccessSecurityScope` and stop it using `stopAccessSecurityScope` when you’ve finished.
    /// >
    /// > ```swift
    /// > .onDrop { sources in
    /// >     try? sources.tryAccessSecurityScope()
    /// >
    /// >     Task {
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
    /// > Use `try?`, because access may already have been started for dropped items.
    ///
    /// - note: This method can only handle drops from finders.
    ///
    /// - Parameters:
    ///   - handler: The handler with an array of the `FinderItems` to the path of the *dropped* items.
    public func onDrop(_ handler: @escaping @MainActor (_ sources: [FinderItem]) throws -> Void) -> DropHandlerView {
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
    private init(prompt: LocalizedStringResource,
                 overlayAlignment: Alignment,
                 isOverlayHidden: Bool,
                 allowMultipleSelection: Bool?,
                 overlay: @escaping (_ isDropTargeted: Bool) -> Overlay,
                 dropHandler: @MainActor @escaping (_: [FinderItem]) throws -> Void
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
    ///   - prompt: The text shown as a prompt. Pass `nil` to use the default prompt.
    public init(prompt: LocalizedStringResource? = nil) where Overlay == EmptyView {
        self.init(prompt: prompt ?? LocalizedStringResource("Drag in files or folder", bundle: #bundle),
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
