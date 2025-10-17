// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "InsuranceDashboard",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "InsuranceDashboard", targets: ["InsuranceDashboardCLI"])
    ],
    targets: [
        .executableTarget(
            name: "InsuranceDashboardCLI",
            path: "Sources/LinuxSupport"
        )
    ]
)
