//
//  􀥣Checkmark.swift
//  ViewCollection
//
//  Created by Vaida on 2025-06-20.
//

import SwiftUI


public struct CheckMarkToggleStyle: ToggleStyle {
    
    public func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            HStack {
                configuration.label
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fontWeight(.regular)
                
                if configuration.isOn {
                    Image(systemName: "checkmark")
                        .fontWeight(.medium)
                }
            }
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
    }
    
}


extension ToggleStyle where Self == CheckMarkToggleStyle {
    
    /// Checkmark style for list
    public static var checkmark: CheckMarkToggleStyle {
        CheckMarkToggleStyle()
    }
    
}


#Preview {
    @Previewable @State var state = false
    
    Toggle("123", isOn: $state)
        .toggleStyle(.checkmark)
        .padding()
}
