//
//  ColorPalette.swift
//  The Stratum Module
//
//  Created by Vaida on 2023/11/13.
//  Copyright © 2019 - 2024 Vaida. All rights reserved.
//

import Foundation
import SwiftUI


/// The Color Palette
///
/// ![Color Palette](bluePalette)
///
/// ![Color Palette](greenPalette)
///
/// ![Color Palette](orangePalette)
/// 
/// ![Color Palette](pinkPalette)
public struct ColorPalette {
    
    
    /// Generates a gradient of blue colors.
    ///
    /// ![Color Palette](bluePalette)
    @inlinable
    public static func blue(of variation: BlueVariations) -> [Color] {
        switch variation {
        case .dark:
            [
                Color(red:   3 / 255, green:   4 / 255, blue:  94 / 255),
                Color(red:   0 / 255, green: 119 / 255, blue: 182 / 255),
                Color(red:   0 / 255, green: 180 / 255, blue: 216 / 255),
                Color(red: 144 / 255, green: 224 / 255, blue: 239 / 255),
                Color(red: 202 / 255, green: 240 / 255, blue: 248 / 255),
            ]
        case .light:
            [
                Color(red: 171 / 255, green: 196 / 255, blue: 255 / 255),
                Color(red: 182 / 255, green: 204 / 255, blue: 254 / 255),
                Color(red: 193 / 255, green: 211 / 255, blue: 254 / 255),
                Color(red: 204 / 255, green: 219 / 255, blue: 253 / 255),
                Color(red: 215 / 255, green: 227 / 255, blue: 252 / 255),
                Color(red: 226 / 255, green: 234 / 255, blue: 252 / 255),
                Color(red: 237 / 255, green: 242 / 255, blue: 251 / 255),
            ]
        case .pure:
            [
                Color(red:  84 / 255, green: 101 / 255, blue: 255 / 255),
                Color(red: 120 / 255, green: 139 / 255, blue: 255 / 255),
                Color(red: 155 / 255, green: 177 / 255, blue: 255 / 255),
                Color(red: 191 / 255, green: 215 / 255, blue: 255 / 255),
                Color(red: 226 / 255, green: 253 / 255, blue: 255 / 255),
            ]
        }
    }
    
    /// Generates a gradient of green colors.
    ///
    /// ![Color Palette](greenPalette)
    @inlinable
    public static func green(of variation: GreenVariations) -> [Color] {
        switch variation {
        case .dark:
            [
                Color(red:  64 / 255, green: 145 / 255, blue: 108 / 255),
                Color(red:  82 / 255, green: 183 / 255, blue: 136 / 255),
                Color(red: 116 / 255, green: 198 / 255, blue: 157 / 255),
                Color(red: 149 / 255, green: 213 / 255, blue: 178 / 255),
                Color(red: 183 / 255, green: 228 / 255, blue: 199 / 255),
                Color(red: 216 / 255, green: 243 / 255, blue: 220 / 255),
            ]
        case .light:
            [
                Color(red:   0 / 255, green: 190 / 255, blue:  68 / 255),
                Color(red:  29 / 255, green: 184 / 255, blue:  83 / 255),
                Color(red:  83 / 255, green: 224 / 255, blue: 135 / 255),
                Color(red: 163 / 255, green: 247 / 255, blue: 192 / 255),
                Color(red: 138 / 255, green: 235 / 255, blue: 174 / 255),
            ]
        }
    }
    
    /// Generates a gradient of orange colors.
    ///
    /// ![Color Palette](orangePalette)
    @inlinable
    public static func orange() -> [Color] {
        [
            Color(red: 255 / 255, green: 123 / 255, blue:   0 / 255),
            Color(red: 255 / 255, green: 149 / 255, blue:   0 / 255),
            Color(red: 255 / 255, green: 170 / 255, blue:   0 / 255),
            Color(red: 255 / 255, green: 195 / 255, blue:   0 / 255),
            Color(red: 255 / 255, green: 221 / 255, blue:   0 / 255),
            Color(red: 255 / 255, green: 238 / 255, blue: 128 / 255),
        ]
    }
    
    /// Generates a gradient of pink colors.
    ///
    /// ![Color Palette](pinkPalette)
    @inlinable
    public static func pink(of variation: PinkVariations) -> [Color] {
        switch variation {
        case .dark:
            [
                Color(red: 240 / 255, green: 128 / 255, blue: 128 / 255),
                Color(red: 244 / 255, green: 151 / 255, blue: 142 / 255),
                Color(red: 248 / 255, green: 173 / 255, blue: 157 / 255),
                Color(red: 251 / 255, green: 196 / 255, blue: 171 / 255),
                Color(red: 255 / 255, green: 218 / 255, blue: 185 / 255),
            ]
        case .light:
            [
                Color(red: 251 / 255, green: 111 / 255, blue: 146 / 255),
                Color(red: 255 / 255, green: 143 / 255, blue: 171 / 255),
                Color(red: 255 / 255, green: 179 / 255, blue: 198 / 255),
                Color(red: 255 / 255, green: 194 / 255, blue: 209 / 255),
                Color(red: 255 / 255, green: 229 / 255, blue: 236 / 255),
            ]
        }
    }
    
    /// Variations to the color `blue`.
    ///
    /// ![Color Palette](bluePalette)
    public enum BlueVariations: String, CaseIterable, Identifiable, Hashable {
        
        /// Dark Blue
        case dark = "Dark Blue"
        
        /// Light Blue
        case light = "Light Blue"
        
        /// Pure Blue
        case pure = "Pure Blue"
        
        
        public var id: String { self.rawValue }
        
    }
    
    /// Variations to the color `green`.
    ///
    /// ![Color Palette](greenPalette)
    public enum GreenVariations: String, CaseIterable, Identifiable, Hashable {
        
        /// Dark Green
        case dark = "Dark Green"
        
        /// Light Green
        case light = "Light Green"
        
        
        public var id: String { self.rawValue }
        
    }
    
    /// Variations to the color `pink`.
    ///
    /// ![Color Palette](pinkPalette)
    public enum PinkVariations: String, CaseIterable, Identifiable, Hashable  {
        
        /// Dark Pink
        case dark = "Dark Pink"
        
        /// Light Pink
        case light = "Light Pink"
        
        
        public var id: String { self.rawValue }
        
    }
    
}



