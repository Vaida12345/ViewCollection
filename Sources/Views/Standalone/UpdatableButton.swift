//
//  UpdatableButton.swift
//  The ViewCollection Module
//
//  Created by Vaida on 2023/10/4.
//  Copyright © 2019 - 2024 Vaida. All rights reserved.
//

import SwiftUI


/// A button which only updates the state when instructed.
///
/// Open an unstructured `Task` only when something makes sense to execute *concurrently* to the `View`'s normal operation, like refreshing the model, not `buttonTapped()` callbacks. 
public struct UpdatableButton<Label>: View where Label: View {
    
    @Binding private var isOn: Bool
    
    private let update: () async throws -> Bool
    
    private let label: () -> Label
    
    
    @State private var isLoading = false
    
    
    public var body: some View {
        HStack {
            label()
            
            Spacer()
            
            ZStack {
                Button {
                    // update states
                    isLoading = true
                    
                    Task {
                        do {
                            guard try await update() else { return }
                            
                            await MainActor.run {
                                isLoading = false
                                isOn.toggle()
                            }
                        } catch {
                            await MainActor.run {
                                isLoading = false
                            }
                        }
                    }
                } label: {
                    Rectangle()
                        .opacity(0)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                
                Toggle("", isOn: $isOn)
                    .allowsHitTesting(false)
                    .disabled(isLoading)
                    .toggleStyle(.switch)
                    .overlay(alignment: .trailing) {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(.circular)
                                .padding(.trailing, isOn ? 2 : 0)
                        }
                    }
            }
        }
    }
    
    /// Creates a button.
    ///
    /// - Parameters:
    ///   - isOn: A binding to a property that determines whether the toggle is on or off.
    ///   - update: The callback when the user tap on the toggle. Returns `true` when the `isOn` should be updated (toggled). Any error thrown is consumed and will not reported to the user.
    ///   - label: A view that describes the purpose of the toggle.
    public init(isOn: Binding<Bool>, update: @escaping () async throws -> Bool, @ViewBuilder label: @escaping () -> Label) {
        self._isOn = isOn
        self.update = update
        self.label = label
    }
}


#Preview {
    
    @Previewable @State var isOn: Bool = false
    
    return UpdatableButton(isOn: $isOn) {
        try await Task.sleep(for: .seconds(2))
        return true
    } label: {
        Text("Tap me")
    }
}
