//
//  DashedSlider.swift
//  The ViewCollection Module
//
//  Created by Vaida on 2023/12/3.
//  Copyright © 2019 - 2024 Vaida. All rights reserved.
//

#if !os(macOS) && !os(visionOS)
import SwiftUI
import CoreHaptics


/// A slider with dashed components indicating position.
///
/// Currently, only vertical scrolling is supported.
///
/// - Important: You should constrain the `frame` `width` to be ``Coordinator-swift.class/Frame-swift.struct/dashSize`` `.width`.
public struct DashedSlider: UIViewControllerRepresentable {
    
    private let coordinator: Coordinator
    
    public func makeCoordinator() -> Coordinator {
        coordinator
    }
    
    public func makeUIViewController(context: Context) -> Controller {
        let controller = Controller()
        controller.scrollView.delegate = coordinator
        return controller
    }
    
    public func updateUIViewController(_ uiViewController: Controller, context: Context) {
        
    }
    
    
    /// Creates the slider with its coordinator.
    public init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
    
    
    /// The container and coordinator to the ``DashedSlider`` ``Coordinator/value``
    public class Coordinator: NSObject, UIScrollViewDelegate, ObservableObject {
        
        /// The value of the slider. Ranged between 0 and 1.
        @Published
        public var value: Double
        
        private let hapticEngine = try? CHHapticEngine()
        
        fileprivate let frame: Frame
        
        /// Crates the coordinator
        public init(value: Double, frame: Frame = Frame(sliderWidth: 60, dashSize: CGSize(width: 20, height: 4))) {
            self.value = value
            self.frame = frame
            
            try? hapticEngine?.start()
        }
        
        public func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let _value = scrollView.contentOffset.y / (frame.dashSize.height + frame.verticalSpacing) / 20
            Task { @MainActor in
                self.value = min(1, max(0, _value))
            }
            
//            print(_value)
            guard _value <= 1 && _value >= 0 else { return }
            let percentage = Int(value * 100)
            guard percentage % 5 == 0 else { return }
            try? self.hapticEngine?.play(pattern: .init(intensity: percentage % 25 == 0 ? 0.75 : 0.5, sharpness: 1))
        }
        
        /// The Coordinator frame.
        public struct Frame {
            
            /// The width of the slider
            fileprivate let sliderWidth: Double
            
            /// The size of each *dash*.
            fileprivate let dashSize: CGSize
            
            fileprivate let verticalSpacing: CGFloat
            
            /// Creates the frame.
            @MainActor
            public init(sliderWidth: Double, dashSize: CGSize) {
                self.sliderWidth = sliderWidth
                self.dashSize = dashSize
                self.verticalSpacing = UIScreen.main.bounds.height / 20 - 4
            }
            
        }
        
    }
    
    
    public class Controller: UIViewController {
        
        private let contentView = UIView()
        
        fileprivate let scrollView = UIScrollView()
        
        private var coordinator: Coordinator {
            scrollView.delegate! as! Coordinator
        }
        
        
        public override func viewDidLoad() {
            super.viewDidLoad()
            
            for i in -10 ..< 30 {
                let yIndex = CGFloat(i + 10)
                let rectangle = UIView(frame: CGRect(x: (coordinator.frame.sliderWidth - coordinator.frame.dashSize.width) / 2, 
                                                     y: (coordinator.frame.verticalSpacing + coordinator.frame.dashSize.height) * yIndex,
                                                     width: coordinator.frame.dashSize.width,
                                                     height: coordinator.frame.dashSize.height))
                rectangle.backgroundColor = UIColor.secondarySystemFill.withAlphaComponent((i < 0 || i > 20) ? 0 : (i % 5 == 0 ? 0.75 : 0.5))
                rectangle.layer.cornerRadius = 2
                rectangle.clipsToBounds = true
                
                contentView.addSubview(rectangle)
            }
            
            scrollView.frame = CGRect(x: 0, y: 0, width: coordinator.frame.sliderWidth, height: self.view.bounds.height)
            scrollView.isDirectionalLockEnabled = true
            scrollView.alwaysBounceVertical = false
            scrollView.showsVerticalScrollIndicator = false
            scrollView.addSubview(contentView)
            scrollView.contentSize = CGSize(width: coordinator.frame.sliderWidth, height: (coordinator.frame.verticalSpacing + coordinator.frame.dashSize.height) * 39)
            scrollView.contentOffset = CGPoint(x: 0, y: (coordinator.frame.verticalSpacing + coordinator.frame.dashSize.height) * 20 * coordinator.value)
            scrollView.delaysContentTouches = false
            
            self.view.addSubview(scrollView)
        }
        
    }
}

#Preview {
    DashedSlider(coordinator: .init(value: 0.5))
}
#endif
