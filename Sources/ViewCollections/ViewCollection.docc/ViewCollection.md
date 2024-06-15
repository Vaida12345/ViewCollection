# ``ViewCollection``

A collection of SwiftUI Views.

@Metadata {
    @PageColor(orange)
    
    @SupportedLanguage(swift)
    
    @Available(macOS,    introduced: 13.0)
    @Available(iOS,      introduced: 16.0)
    @Available(watchOS,  introduced: 9.0)
    @Available(tvOS,     introduced: 16.0)
    @Available(visionOS, introduced: 1.0)
}


## Overview

This package provides a collection of stand-alone SwiftUI Views. The views in the `Nucleus` framework provides the foundation functionalities.

## Getting Started

`ViewCollection` uses [Swift Package Manager](https://www.swift.org/documentation/package-manager/) as its build tool. If you want to import in your own project, it's as simple as adding a `dependencies` clause to your `Package.swift`:
```swift
dependencies: [
    .package(name: "ViewCollection", 
             path: "~/Library/Mobile Documents/com~apple~CloudDocs/DataBase/Projects/Packages/ViewCollection")
]
```
and then adding the appropriate module to your target dependencies.

### Using Xcode Package support

You can add this framework as a dependency to your Xcode project by clicking File -> Swift Packages -> Add Package Dependency. The package is located at:
```
~/Library/Mobile Documents/com~apple~CloudDocs/DataBase/Projects/Packages/ViewCollection
```

## Topics

### Views
The stand-alone views.

- ``AsyncView``
- ``BlurredEffectView``
- ``ColorPaletteView``
- ``DashedSlider``
- ``GalleryView``
- ``ImagePreviewView``
- ``TextAutoCompleteField``
- ``UpdatableButton``
- ``FinderItemView``

### Modifiers
A set of view modifiers.

- ``SwiftUI/View/animatedAppearing(_:)``
- ``SwiftUI/View/onSwipe(to:sensitivity:maxDistance:progress:disabled:handler:)``


### Styles
The styles to the SwiftUI defined views.

- ``SwiftUI/ButtonStyle/large(color:)``
- ``SwiftUI/ProgressViewStyle/simpleCircular``
- ``SwiftUI/ProgressViewStyle/simpleLinear``

### Layouts
A set of customized layouts.

- ``EqualWidthHStack``
- ``EqualWidthVStack``
- ``FilledVGrid``
- ``ContainerView``

### Structures
A set of auxiliary structure working with `SwiftUI` to deliver the views.

- ``ColorPalette``
- ``DesignPattern``
- ``MutableBinding``
