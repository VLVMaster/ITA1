// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "InsuranceDashboard",
    platforms: [
        .iOS(.v17),
        .macOS(.v13)
    ],
    products: [
        .executable(name: "InsuranceDashboard", targets: ["InsuranceDashboard"])
    ],
    targets: [
        .executableTarget(
            name: "InsuranceDashboard",
            path: "Sources/InsuranceDashboard"
        )
    ]
)
