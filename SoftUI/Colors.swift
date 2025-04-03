//
//  Colors.swift
//  ViewCollection
//
//  Created by Vaida on 4/3/25.
//

import SwiftUICore
import ViewCollection


extension Color {
    
    /// A set of colors for SoftUI.
    public static var soft: Soft.Type {
        Soft.self
    }
    
    /// A set of colors for SoftUI.
    public enum Soft {
        
        /// The main foreground and background color.
        static var main: Color {
            Color {
                Color(red: 0.925, green: 0.941, blue: 0.953)
            } dark: {
                Color(red: 0.188, green: 0.192, blue: 0.208)
            }
        }
        
        /// The secondary color, often used as text color.
        static var secondary: Color {
            Color {
                Color(red: 0.482, green: 0.502, blue: 0.549)
            } dark: {
                Color(red: 0.910, green: 0.910, blue: 0.910)
            }
        }
        
        /// The light shadow
        static var lightShadow: Color {
            Color {
                Color.white
            } dark: {
                Color(red: 0.243, green: 0.247, blue: 0.275)
            }
        }
        
        /// The dark shadow
        static var darkShadow: Color {
            Color {
                Color(red: 0.820, green: 0.851, blue: 0.902)
            } dark: {
                Color(red: 0.137, green: 0.137, blue: 0.137)
            }
        }
        
    }
    
}
