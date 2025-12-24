//
//  NativeView.swift
//  ViewCollection
//
//  Created by Vaida on 2025-12-24.
//

import SwiftUI
import ViewCollection


struct _NativeViewController: NativeViewControllerRepresentable {
     
    func makeViewController(context: Context) -> NativeViewController {
        NativeViewController()
    }
    
    func updateViewController(_ viewController: NativeViewController, context: Context) {
        
    }
    
}
