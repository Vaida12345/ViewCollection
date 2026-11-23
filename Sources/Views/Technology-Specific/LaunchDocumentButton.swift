//
//  LaunchDocumentButton.swift
//  ViewCollection
//
//  Created by Vaida on 2025-08-22.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import SwiftUI
import FinderItem
import Essentials


/// The button for launching document.
///
/// ## Topics
/// ### Default Label
/// - ``DefaultLaunchDocumentLabel``
public struct LaunchDocumentButton<Label: View>: View {
    
    let label: Label
    
    let item: FinderItem?
    
    let action: Action
    
    let dismiss: DismissAction?
    
    
    public var body: some View {
        Button {
            guard let item else { return }
            switch action {
            case .open:
                Task { [item] in
                    await withErrorPresented(LocalizedStringResource("Failed to open \(item.name)", bundle: #bundle)) {
                        try await item.open()
                    }
                }
                
            case .reveal:
                Task { [item] in
                    await withErrorPresented(LocalizedStringResource("Failed to reveal \(item.name)", bundle: #bundle)) {
                        try await item.reveal()
                    }
                }
            }
            
            dismiss?()
        } label: {
            label
        }
        .help(action.help(name: item?.name))
    }
    
    
    /// Creates with a customized label.
    ///
    /// - Parameters:
    ///   - action: The action of the button
    ///   - item: The target
    ///   - dismiss: When specified, perform the dismiss action when the user clicked on the button
    ///   - label: The label of the button
    public init(_ action: Action = .open, item: FinderItem?, dismiss: DismissAction? = nil, @ViewBuilder label: () -> Label) {
        self.action = action
        self.label = label()
        self.item = item
        self.dismiss = dismiss
    }
    
    /// Creates with the default label.
    ///
    /// - Parameters:
    ///   - action: The action of the button
    ///   - item: The target
    ///   - dismiss: When specified, perform the dismiss action when the user clicked on the button
    public init(_ action: Action = .open, item: FinderItem?, dismiss: DismissAction? = nil) where Label == DefaultLaunchDocumentLabel {
        self.action = action
        self.label = DefaultLaunchDocumentLabel(action: action)
        self.item = item
        self.dismiss = dismiss
    }
    
    
    /// The action.
    public enum Action {
        
        /// Reveal in Finder.
        case reveal
        
        /// Open the document using the default app.
        case open
        
        
        var title: LocalizedStringResource {
            switch self {
            case .open: LocalizedStringResource("Open", bundle: #bundle)
            case .reveal: LocalizedStringResource("Show in Finder", bundle: #bundle)
            }
        }
        
        var systemName: String {
            switch self {
            case .open: return "arrow.up.right.square"
            case .reveal:
                if #available(macOS 26, *) {
                    return "finder"
                } else {
                    return "document.viewfinder.fill"
                }
            }
        }
        
        func help(name: String?) -> LocalizedStringResource {
            if let name {
                switch self {
                case .reveal:
                    LocalizedStringResource("Show \(name) in Finder", bundle: #bundle)
                case .open:
                    LocalizedStringResource("Open \(name) with external software", bundle: #bundle)
                }
            } else {
                switch self {
                case .reveal:
                    LocalizedStringResource("Show in Finder", bundle: #bundle)
                case .open:
                    LocalizedStringResource("Open with external software", bundle: #bundle)
                }
            }
        }
        
    }
    
}

/// The default label for launching document.
public struct DefaultLaunchDocumentLabel: View {
    
    let action: LaunchDocumentButton<DefaultLaunchDocumentLabel>.Action
    
    public var body: some View {
        Label(action.title, systemImage: action.systemName)
    }
}


#Preview {
    LaunchDocumentButton(.open, item: .homeDirectory)
        .padding()
}
#endif
