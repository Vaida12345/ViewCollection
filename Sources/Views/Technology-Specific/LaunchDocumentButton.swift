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
    
    let item: FinderItem
    
    let action: Action
    
    
    public var body: some View {
        Button {
            switch action {
            case .open:
                Task { [item] in
                    await withErrorPresented("Failed to open \(item.name)") {
                        try await item.open()
                    }
                }
                
            case .reveal:
                Task { [item] in
                    await withErrorPresented("Failed to reveal \(item.name)") {
                        try await item.reveal()
                    }
                }
            }
        } label: {
            label
        }
        .help(action.help(name: item.name))
    }
    
    
    /// Creates with a customized label.
    public init(_ action: Action = .open, item: FinderItem, @ViewBuilder label: () -> Label) {
        self.action = action
        self.label = label()
        self.item = item
    }
    
    /// Creates with the default label.
    public init(_ action: Action = .open, item: FinderItem) where Label == DefaultLaunchDocumentLabel {
        self.action = action
        self.label = DefaultLaunchDocumentLabel(action: action)
        self.item = item
    }
    
    
    /// The action.
    public enum Action {
        
        /// Reveal in Finder.
        case reveal
        
        /// Open the document using the default app.
        case open
        
        
        var title: LocalizedStringKey {
            switch self {
            case .open: "Open"
            case .reveal: "Show in Finder"
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
        
        func help(name: String) -> LocalizedStringKey {
            switch self {
            case .reveal:
                "Show \(name) in Finder"
            case .open:
                "Open \(name) with external software"
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
}
#endif
