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
    
    let isAnimated: Bool
    
    
    public func makeBody(configuration: Configuration) -> some View {
        Group {
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
                
            case .fill:
                Button {
                    configuration.isOn.toggle()
                } label: {
                    configuration.label
                        .foregroundStyle(configuration.isOn ? foregroundColor : Color.soft.secondary)
                }
            }
        }
        .buttonStyle(.soft(shape: shape).animated(isAnimated))
    }
    
    
    /// Indicates that transitions should be shown on view appear.
    ///
    /// - Warning: When `animated`, the view must attach `transitionPhaseExposing()`
    public func animated(_ animated: Bool = true) -> SoftToggleStyle {
        SoftToggleStyle(style: style, shape: shape, foregroundColor: foregroundColor, isAnimated: animated)
    }
    
    
    public enum Style {
        /// A leading indicator
        case indicator
        /// Designed for showing symbols, change the color of the symbol.
        case fill
    }
    
    
    init(style: Style, shape: S, foregroundColor: Color = .accentColor, isAnimated: Bool = false) {
        self.style = style
        self.shape = shape
        self.foregroundColor = foregroundColor
        self.isAnimated = isAnimated
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
    .colorScheme(.light)
}
