// swift-tools-version: 5.9
import PackageDescription

let products: [Product]

#if os(Linux)
products = [
    .executable(name: "InsuranceDashboard", targets: ["InsuranceDashboard"])
]
#else
products = [
    .iOSApplication(
        name: "InsuranceDashboard",
        targets: ["InsuranceDashboard"],
        bundleIdentifier: "com.example.insurancedashboard",
        teamIdentifier: nil,
        displayVersion: "1.0",
        bundleVersion: "1",
        iconAssetName: nil,
        accentColorAssetName: nil,
        supportedDeviceFamilies: [
            .pad,
            .phone
        ],
        supportedInterfaceOrientations: [
            .portrait,
            .landscapeRight,
            .landscapeLeft,
            .portraitUpsideDown
        ]
    )
]
#endif

let package = Package(
    name: "InsuranceDashboard",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: products,
    targets: [
        .executableTarget(
            name: "InsuranceDashboard",
            path: "Sources/App"
        )
    ]
)
