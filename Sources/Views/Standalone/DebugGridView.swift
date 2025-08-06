//
//  DebugGridView.swift
//  ViewCollection
//
//  Created by Vaida on 2025-06-05.
//

import SwiftUI


/// A grid for debugging purposes.
/// 
/// ```swift
/// ZStack {
///     DebugGridView()
///     Rectangle()
///         .frame(CGRect(x: 10, y: 10, width: 20, height: 20))
/// }
/// .frame(width: 100, height: 100)
/// ```
///
/// ![Preview](frame)
public struct DebugGridView: View {
    
    private let stride: Int
    
    public var body: some View {
        Canvas { context, size in
            func width(_ i: Int) -> CGFloat {
                if i % 100 == 0 { return 1 }
                if i % 10 == 0 { return 0.1 }
                if i % 1000 == 0 { return 3 }
                return 0.01
            }
            
            for i in Swift.stride(from: 0, through: size.width, by: 10) {
                context.fill(CGRect(x: i, y: 0, width: width(Int(i)), height: size.height), with: .foreground)
            }
            for i in Swift.stride(from: 0, through: size.height, by: 10) {
                context.fill(CGRect(x: 0, y: i, width: size.width, height: width(Int(i))), with: .foreground)
            }
        }
    }
    
    public init(stride: Int = 10) {
        self.stride = stride
    }
    
}


#Preview {
    DebugGridView()
}

