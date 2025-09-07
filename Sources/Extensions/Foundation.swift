//
//  Foundation.swift
//  ViewCollection
//
//  Created by Vaida on 2025-09-07.
//

import Foundation


extension ProcessInfo {
    
    /// Checks if the process currently runs in Xcode Preview environment.
    @inlinable
    public var isPreview: Bool {
#if DEBUG
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
#else
        false
#endif
    }
    
}
