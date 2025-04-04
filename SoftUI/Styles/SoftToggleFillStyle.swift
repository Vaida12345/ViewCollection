//
//  SoftToggleFillStyle.swift
//  ViewCollection
//
//  Created by Vaida on 4/3/25.
//

import SwiftUI


public struct SoftToggleStyle<S: Shape>: ToggleStyle {
    
    let shape: S
    
    let foregroundColor: Color
    
    let style: Style
    
    
    public func makeBody(configuration: Configuration) -> some View {
        switch self.style {
        case .indicator:
            Button {
                configuration.isOn.toggle()
            } label: {
                HStack(spacing: 20) {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(configuration.isOn ? foregroundColor : Color.soft.lightShadow)
                        .frame(width: 4, height: 20)
                    
                    configuration.label
                        .foregroundStyle(Color.soft.secondary)
                }
                .padding()
            }
            .buttonStyle(SoftButtonStyle(shape: shape))
            
        case .fill:
            Button {
                configuration.isOn.toggle()
            } label: {
                configuration.label
                    .foregroundStyle(configuration.isOn ? foregroundColor : Color.soft.secondary)
            }
            .buttonStyle(SoftButtonStyle(shape: shape))
        }
    }
    
    
    public enum Style {
        /// A leading indicator
        case indicator
        /// Designed for showing symbols, change the color of the symbol.
        case fill
    }
    
    
    init(style: Style, shape: S, foregroundColor: Color = .accentColor) {
        self.style = style
        self.shape = shape
        self.foregroundColor = foregroundColor
    }
    
}


extension ToggleStyle where Self == SoftToggleStyle<AnyShape> {
    
    /// A Soft UI style toggle.
    public static func soft<S: Shape>(_ style: SoftToggleStyle<S>.Style, shape: S, foregroundColor: Color = .accentColor) -> SoftToggleStyle<S> {
        SoftToggleStyle(style: style, shape: shape, foregroundColor: foregroundColor)
    }
    
}


#Preview {
    @Previewable @State var state = false
    
    ZStack {
        Color.soft.main.ignoresSafeArea(.all)
        
        Toggle(isOn: $state) {
            Image(systemName: "car")
                .padding()
        }
        .toggleStyle(.soft(.fill, shape: .rect(cornerRadius: 10)))
    }
    .colorScheme(.dark)
}
