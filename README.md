# InsuranceDashboard Swift Package

This package contains a SwiftUI implementation of the Insurance Dashboard app.

## Building on Linux

The package includes a lightweight CLI entry point that allows the project to
compile on Linux so automated checks can run:

```
swift build
```

## Running in Xcode

When the package is opened in Xcode on macOS you will see an iOS application
scheme named **InsuranceDashboard**. Choose an iPhone or iPad destination and
build/run to launch the SwiftUI app. The iOS application product includes arm64
support so it can be deployed to physical devices without architecture errors.