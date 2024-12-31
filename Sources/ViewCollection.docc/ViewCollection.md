# ``ViewCollection``

A collection of SwiftUI Views.

@Metadata {
    @PageColor(orange)
    
    @SupportedLanguage(swift)
    
    @Available(macOS,    introduced: 14.0)
    @Available(iOS,      introduced: 17.0)
    @Available(watchOS,  introduced: 10.0)
    @Available(tvOS,     introduced: 17.0)
    @Available(visionOS, introduced: 1.0)
}


## Overview

This package provides a collection of stand-alone SwiftUI Views.

## Getting Started

`ViewCollection` uses [Swift Package Manager](https://www.swift.org/documentation/package-manager/) as its build tool. If you want to import in your own project, it's as simple as adding a `dependencies` clause to your `Package.swift`:
```swift
dependencies: [
    .package(url: "https://github.com/Vaida12345/ViewCollection")
]
```
and then adding the appropriate module to your target dependencies.

### Using Xcode Package support

You can add this framework as a dependency to your Xcode project by clicking File -> Swift Packages -> Add Package Dependency. The package is located at:
```
https://github.com/Vaida12345/ViewCollection
```

## Topics

### Contained Views
- ``ContainerView``
- ``AsyncView``
- ``withStateObserved(initial:handler:)``

### Medias
- ``AsyncDrawnImage``
- ``BlurredEffectView``
- ``CrossFadeImage``
- ``FramedImage``

### Sliders
-  ``DashedSlider``
- ``InfDashedSlider``
- ``MediaSlider``
- ``PlainSlider``

### Views
The stand-alone views.

- ``CheckMarkView``
- ``ColorPaletteView``
- ``ImagePreviewView``
- ``TextAutoCompleteField``
- ``UpdatableButton``

### Technology-specific
- ``DropHandlerView``
- ``FinderItemView``

### Modifiers
A set of view modifiers.

- ``SwiftUICore/View/floatingSheet(isPresented:onDismiss:content:)``
- ``SwiftUICore/EnvironmentValues/dismissFloatingSheet``
- ``SwiftUICore/View/onSwipe(to:sensitivity:maxDistance:progress:disabled:handler:)``
- ``SwiftUICore/View/animatedAppearing(_:)``
- ``SwiftUICore/View/dragToRepositionWindow()``
- ``SwiftUICore/View/modifier(enabled:content:)``
- ``SwiftUICore/View/modifier(enabled:content:else:)``
- ``SwiftUICore/View/reverseMask(alignment:_:)``


### Styles
The styles to the SwiftUI defined views.

- ``SwiftUI/ButtonStyle/circular``
- ``SwiftUI/ButtonStyle/largeCapsule(color:)``
- ``SwiftUI/ButtonStyle/borderedWide``
- ``SwiftUI/ProgressViewStyle/simpleCircular``
- ``SwiftUI/ProgressViewStyle/simpleLinear``

### Layouts
A set of customized layouts.

- ``EqualWidthHStack``
- ``EqualWidthVStack``
- ``FilledVGrid``
- ``GalleryView``

### Structures
A set of auxiliary structure working with `SwiftUI` to deliver the views.

- ``ColorPalette``
- ``DataProvider``
- ``DesignPattern``
- ``Untracked``
- ``WindowManager``
- ``MutableBinding``

### NativeViews
A set of type alias for platform-dependent classes in UIKit / AppKit
- ``ApplicationDelegate``
- ``ApplicationDelegateAdaptor``
- ``NativeColor``
- ``NativeView``
- ``NativeViewController``
- ``NativeViewRepresentable``
- ``NativeViewControllerRepresentable``

### Bundle Extensions
- ``Foundation/Bundle/load(_:)``
- ``Foundation/Bundle/ResourceKey``

### GridItem Extensions
- ``SwiftUI/GridItem/fixed(_:)``

### Picker Extensions
- ``SwiftUI/Picker/init(_:selection:)``
- ``SwiftUI/Picker/init(_:selection:options:)-5zk7b``
- ``SwiftUI/Picker/init(_:selection:options:)-7l1f``

### Binding Extensions
- ``SwiftUICore/Binding/double``
- ``SwiftUICore/Binding/float``
- ``SwiftUICore/Binding/isEqual(to:or:)``
- ``SwiftUICore/Binding/==(_:_:)``
- ``SwiftUICore/Binding/!=(_:_:)``

### Color Extensions
- ``SwiftUICore/Color/allColors``
- ``SwiftUICore/Color/animatableData``

